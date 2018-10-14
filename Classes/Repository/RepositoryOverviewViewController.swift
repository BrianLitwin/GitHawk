//
//  RepositoryOverviewViewController.swift
//  Freetime
//
//  Created by Ryan Nystrom on 9/20/17.
//  Copyright © 2017 Ryan Nystrom. All rights reserved.
//

import UIKit
import IGListKit
import GitHubAPI
import SnapKit

class HackScrollIndicatorInsetsCollectionView: UICollectionView {
    override var scrollIndicatorInsets: UIEdgeInsets {
        set {
            super.scrollIndicatorInsets = UIEdgeInsets(top: newValue.top, left: 0, bottom: newValue.bottom, right: 0)
        }
        get { return super.scrollIndicatorInsets }
    }
}

class RepositoryOverviewViewController: BaseListViewController<NSString>,
BaseListViewControllerDataSource,
RepositoryBranchUpdatable,
RoutesRepositoryLink
{
    private let repo: RepositoryDetails
    private let client: RepositoryClient
    private var readme: RepositoryReadmeModel?
    private var branch: String

//    lazy var _feed: Feed = { Feed(
//        viewController: self,
//        delegate: self,
//        collectionView: HackScrollIndicatorInsetsCollectionView(
//            frame: .zero,
//            collectionViewLayout: ListCollectionViewLayout.basic()
//        ))
//    }()
//    override var feed: Feed {
//        return _feed
//    }

    init(client: GithubClient, repo: RepositoryDetails) {
        self.repo = repo
        self.client = RepositoryClient(githubClient: client, owner: repo.owner, name: repo.name)
        self.branch = repo.defaultBranch
        super.init(
            emptyErrorMessage: NSLocalizedString("Cannot load README.", comment: "")
        )
        self.dataSource = self
        title = NSLocalizedString("Overview", comment: "")
//        self.feed.collectionView.contentInset = UIEdgeInsets(
//            top: Styles.Sizes.rowSpacing,
//            left: Styles.Sizes.gutter,
//            bottom: Styles.Sizes.rowSpacing,
//            right: Styles.Sizes.gutter
//        )
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        feed.collectionView.backgroundColor = .white
        makeBackBarItemEmpty()
    }

    // MARK: Overrides

    override func fetch(page: NSString?) {
        let repo = self.repo
        let width = view.bounds.width - Styles.Sizes.gutter * 2
        let contentSizeCategory = UIContentSizeCategory.preferred
        let branch = self.branch

        client.githubClient.client
            .send(V3RepositoryReadmeRequest(owner: repo.owner, repo: repo.name, branch: branch)) { [weak self] result in
            switch result {
            case .success(let response):
                DispatchQueue.global().async {

                    let models = MarkdownModels(
                        response.data.content,
                        owner: repo.owner,
                        repo: repo.name,
                        width: width,
                        viewerCanUpdate: false,
                        contentSizeCategory: contentSizeCategory,
                        isRoot: false,
                        branch: branch
                    )
                    let model = RepositoryReadmeModel(models: models)
                    DispatchQueue.main.async { [weak self] in
                        self?.readme = model
                        self?.update(animated: trueUnlessReduceMotionEnabled)
                    }
                }
            case .failure:
                self?.error(animated: trueUnlessReduceMotionEnabled)
            }
        }
    }

    // MARK: BaseListViewControllerDataSource

    func headModels(listAdapter: ListAdapter) -> [ListDiffable] {
        return []
    }

    func models(listAdapter: ListAdapter) -> [ListDiffable] {
        guard let readme = self.readme else { return [] }
        return [readme]
    }

    func sectionController(model: Any, listAdapter: ListAdapter) -> ListSectionController {
        return RepositoryReadmeSectionController()
    }

    func emptySectionController(listAdapter: ListAdapter) -> ListSectionController {
        return RepositoryEmptyResultsSectionController(
            topInset: 0,
            layoutInsets: view.safeAreaInsets, 
            type: .readme
        )
    }
    
    //Mark: RepositoryBranchUpdatable
    
    func updateBranch(to newBranch: String) {
        guard self.branch != newBranch else { return }
        self.branch = newBranch
        fetch(page: nil)
    }
    
    //Mark: RoutesRepositoryLink

    func presentRepository(_ repositoryLink: RepositoryLink) {
        
        let spinnerView = SpinnerView()
        spinnerView.startAnimating()
        view.addSubview(spinnerView)
        
        spinnerView.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.centerX)
            make.centerY.equalTo(view.snp.centerY).offset(-view.frame.height * 0.1)
        }
        
        let query = RepositoryDetailsQuery(
            owner: repositoryLink.owner,
            name: repositoryLink.name
        )
        
        func fallbackToSafari() {
            if let url = URL(string: repositoryLink.url) {
                presentSafari(url: url)
            }
        }

        client.githubClient.client.query(query, result: { $0 }) { [weak self] result in
            guard let strongSelf = self else { return }
            
            switch result {
            case .failure:
                fallbackToSafari()
                
            case .success(let details):
                if let defaultBranch = details.repository?.defaultBranchRef?.name,
                    let hasIssuesEnabled = details.repository?.hasIssuesEnabled
                {
                    let repo = RepositoryDetails(
                        owner: repositoryLink.owner,
                        name: repositoryLink.name,
                        defaultBranch: defaultBranch,
                        hasIssuesEnabled: hasIssuesEnabled
                    )
                    
                    let vc = RepositoryViewController(
                        client: strongSelf.client.githubClient,
                        repo: repo
                    )
                    
                    strongSelf.show(vc, sender: self)
                } else {
                    fallbackToSafari()
                }
            }
        
            spinnerView.removeFromSuperview()
        }
    }
}



class SpinnerView: UIView {
    
    private let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = 10.0
        backgroundColor = UIColor.lightGray.withAlphaComponent(0.9)
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(activityIndicator)
        
        activityIndicator.snp.makeConstraints { make in
            make.centerX.equalTo(self.snp.centerX)
            make.top.equalTo(self.snp.top).offset(30)
            make.bottom.equalTo(self.snp.bottom).offset(-30)
            make.leading.equalTo(self.snp.leading).offset(35)
            make.trailing.equalTo(self.snp.trailing).offset(-35)
        }
    }
    
    public func startAnimating() {
        activityIndicator.startAnimating()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
