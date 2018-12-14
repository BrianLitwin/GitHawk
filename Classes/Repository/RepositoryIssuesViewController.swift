//
//  RepositoryIssuesViewController.swift
//  Freetime
//
//  Created by Ryan Nystrom on 9/20/17.
//  Copyright © 2017 Ryan Nystrom. All rights reserved.
//

import UIKit
import IGListKit
import XLPagerTabStrip

enum RepositoryIssuesType {
    case issues
    case pullRequests
}

final class RepositoryIssuesViewController: BaseListViewController<String>,
    BaseListViewControllerDataSource,
    BaseListViewControllerEmptyDataSource,
    BaseListViewControllerHeaderDataSource,
    SearchBarSectionControllerDelegate,
IndicatorInfoProvider,
LabelListViewDelegate {
    
    private var models = [RepositoryIssueSummaryModel]()
    private let owner: String
    private let repo: String
    private let client: RepositoryClient
    private let type: RepositoryIssuesType
    private let searchKey: ListDiffable = "searchKey" as ListDiffable
    private let debouncer = Debouncer()
    private var searchBarModel: RepositorySearchBarQueryModel
    
    private var searchBarSectionController: SearchBarSectionController? {
        return feed.swiftAdapter.sectionController(
            for: SearchBarSectionController.listSwiftId
        )
    }

    init(client: GithubClient, owner: String, repo: String, type: RepositoryIssuesType, label: String? = nil) {
        self.owner = owner
        self.repo = repo
        self.client = RepositoryClient(githubClient: client, owner: owner, name: repo)
        self.type = type
        searchBarModel = RepositorySearchBarQueryModel(
            type: type,
            repo: repo,
            owner: owner,
            label: label
        )
        super.init(
            emptyErrorMessage: NSLocalizedString("Cannot load issues.", comment: "")
        )

        self.dataSource = self
        self.emptyDataSource = self
        self.headerDataSource = self

        switch type {
        case .issues: title = NSLocalizedString("Issues", comment: "")
        case .pullRequests: title = NSLocalizedString("Pull Requests", comment: "")
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        makeBackBarItemEmpty()

        // TODO: this is no longer valid -> can search labels from repositoryIssues VS
        let presentingInTabMan = false
        if presentingInTabMan {
            // set the frame in -viewDidLoad is required when working with TabMan
            feed.collectionView.frame = view.bounds
            feed.collectionView.contentInsetAdjustmentBehavior = .never
        }
    }

    // MARK: Overrides

    override func fetch(page: String?) {
        client.searchIssues(
            query: searchBarModel.fullQueryString,
            nextPage: page as String?,
            containerWidth: view.safeContentWidth(with: feed.collectionView)
        ) { [weak self] (result: Result<RepositoryClient.RepositoryPayload>) in
            switch result {
            case .error:
                self?.error(animated: trueUnlessReduceMotionEnabled)
            case .success(let payload):
                if page != nil {
                    self?.models += payload.models
                } else {
                    self?.models = payload.models
                }
                self?.update(page: payload.nextPage, animated: trueUnlessReduceMotionEnabled)
            }
        }
    }

    // MARK: SearchBarSectionControllerDelegate

    func didChangeSelection(sectionController: SearchBarSectionController, query: String) {
        guard searchBarModel.searchString != query else { return }
        searchBarModel.set(query: query)
        debouncer.action = { [weak self] in self?.fetch(page: nil) }
    }

    // MARK: BaseListViewControllerHeaderDataSource

    func headerModel(for adapter: ListSwiftAdapter) -> ListSwiftPair {
        return ListSwiftPair.pair("header", { [weak self ] in
            SearchBarSectionController(
                placeholder: Constants.Strings.search,
                delegate: self,
                query: self?.searchBarModel.searchString ?? ""
            )
        })
    }

    // MARK: BaseListViewControllerDataSource

    func models(adapter: ListSwiftAdapter) -> [ListSwiftPair] {
        return models.map { [client, owner, repo] model in
            ListSwiftPair.pair(model, {
                RepositorySummarySectionController(
                    client: client.githubClient,
                    owner: owner,
                    repo: repo,
                    labelListViewDelegate: self
                )
            })
        }
    }

    // MARK: BaseListViewControllerEmptyDataSource

    func emptyModel(for adapter: ListSwiftAdapter) -> ListSwiftPair {
        let layoutInsets = view.safeAreaInsets
        let empty: RepositoryEmptyResultsType
        switch type {
        case .issues: empty = .issues
        case .pullRequests: empty = .pullRequests
        }
        return ListSwiftPair.pair("empty") {
            RepositoryEmptyResultsSectionController2(layoutInsets: layoutInsets, type: empty)
        }
    }

    // MARK: IndicatorInfoProvider

    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: title)
    }

    // MARK: LabelListViewTapDelegate
    
    func labelListView(_ labelListView: LabelListView, didTapLabel label: String) {
        guard let controller = searchBarSectionController else { return }
        let query = searchBarModel.queryFor(label: label)
        controller.setSearchBarQuery(query)
        // scroll to top
    }

}
