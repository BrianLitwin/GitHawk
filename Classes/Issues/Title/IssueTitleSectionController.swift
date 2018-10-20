//
//  IssueTitleSectionController.swift
//  Freetime
//
//  Created by Ryan Nystrom on 5/19/17.
//  Copyright © 2017 Ryan Nystrom. All rights reserved.
//

import UIKit
import IGListKit
import GitHubAPI

protocol IssueTitleSectionControllerDelegate: class {
    func sendEditTitleRequest(title: String)
}

final class IssueTitleSectionController: ListSectionController {

    var object: IssueTitleModel?
    weak var delegate: IssueTitleSectionControllerDelegate?

    init(delegate: IssueTitleSectionControllerDelegate) {
        super.init()
        self.delegate = delegate
        inset = UIEdgeInsets(top: Styles.Sizes.rowSpacing, left: 0, bottom: 0, right: 0)
    }

    override func didUpdate(to object: Any) {
        guard let object = object as? IssueTitleModel else { return }
        self.object = object
    }

    override func sizeForItem(at index: Int) -> CGSize {
        guard let width = collectionContext?.insetContainerSize.width
            else { fatalError("Collection context must be set") }
        return CGSize(width: width, height: self.object?.string.viewSize(in: width).height ?? 0)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let object = self.object,
            let cell = collectionContext?.dequeueReusableCell(of: IssueTitleCell.self, for: self, at: index) as? IssueTitleCell
            else { fatalError("Collection context must be set, missing object, or cell incorrect type") }
        cell.set(renderer: object.string)
        return cell
    }
    
    override func didSelectItem(at index: Int) {
        guard let object = self.object else { return }
        let title = "Update Date in Workout History after changing it in workout"
        delegate?.sendEditTitleRequest(title: title)
    }

}
