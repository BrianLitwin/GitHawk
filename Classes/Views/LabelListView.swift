//
//  LabelListView.swift
//  Freetime
//
//  Created by Joe Rocca on 12/6/17.
//  Copyright © 2017 Ryan Nystrom. All rights reserved.
//

import Foundation
import SnapKit

protocol LabelListViewDelegate: class {
    func labelListView(_ labelListView: LabelListView, didTapLabel label: String)
}

final class LabelListView: UIView,
UICollectionViewDataSource,
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout {

    private static var cache = [String: CGFloat]()
    private weak var delegate: LabelListViewDelegate?
    
    static func width(labels: [RepositoryLabel]) -> CGFloat {
        let key = labels.reduce("width: ", {$0 + $1.name})
        print(key)
        if let cachedWidth = cache[key] {
            print("returning cached width: \(cachedWidth)")
            return cachedWidth
        }
        let interitemSpacing = labels.count > 1 ? CGFloat(labels.count - 1) * Styles.Sizes.labelSpacing : 0.0
        let width =  labels.reduce(0, { $0 + LabelListCell.size($1.name).width }) + interitemSpacing
        LabelListView.cache[key] = width
        print("returning calculated width: \(width)")
        return width
    }

    static func height(width: CGFloat, labels: [RepositoryLabel], cacheKey: String) -> CGFloat {
        let key = "\(cacheKey)\(width)"
        if let cachedHeight = LabelListView.cache[key] {
            return cachedHeight
        }

        let rowHeight = LabelListCell.size(labels.first?.name ?? "").height
        let labelRows = ceil(LabelListView.width(labels: labels) / width)
        let rowSpacing = labelRows > 1 ? (labelRows - 1) * Styles.Sizes.labelSpacing : 0.0

        let height = ceil((rowHeight * labelRows) + rowSpacing)
        LabelListView.cache[key] = height

        return height
    }

    var labels = [RepositoryLabel]()

    let collectionView: UICollectionView = {
        let layout = WrappingStaticSpacingFlowLayout(interitemSpacing: Styles.Sizes.labelSpacing,
                                                     rowSpacing: Styles.Sizes.labelSpacing)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(LabelListCell.self, forCellWithReuseIdentifier: LabelListCell.reuse)
        collectionView.backgroundColor = UIColor.clear
        collectionView.isScrollEnabled = false
        return collectionView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        collectionView.delegate = self
        collectionView.dataSource = self
        addSubview(collectionView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let width = min(LabelListView.width(labels: labels), bounds.width)
        collectionView.frame = bounds 
    }

    // MARK: UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return labels.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LabelListCell.reuse, for: indexPath) as! LabelListCell
        let label = labels[indexPath.row]
        cell.configure(label: label)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let label = labels[indexPath.row]
        return LabelListCell.size(label.name)
    }
    
    //MARK: UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.labelListView(self, didTapLabel: labels[indexPath.row].name)
    }

    // MARK: Public API

    func configure(labels: [RepositoryLabel], delegate: LabelListViewDelegate?) {
        self.labels = labels
        self.delegate = delegate
        collectionView.reloadData()
    }
}
