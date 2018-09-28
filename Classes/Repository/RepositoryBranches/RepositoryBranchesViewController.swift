//
//  RepoBranchesViewController.swift
//  Freetime
//
//  Created by B_Litwin on 9/25/18.
//  Copyright © 2018 Ryan Nystrom. All rights reserved.
//

import UIKit
import Squawk
import IGListKit

final class RepositoryBranchesViewController: BaseListViewController2<String>,
BaseListViewController2DataSource,
RepositoryBranchSectionControllerDelegate
{

    private let owner: String
    private let repo: String
    private let client: GithubClient
    public var repoBranches: RepositoryBranches
    
    init(repoBranches: RepositoryBranches,
         owner: String,
         repo: String,
         client: GithubClient
        )
    {
        self.repoBranches = repoBranches
        self.owner = owner
        self.repo = repo
        self.client = client
        super.init(emptyErrorMessage: "Couldn't load repository branches")
        
        title = Constants.Strings.branches
        preferredContentSize = Styles.Sizes.contextMenuSize
        feed.collectionView.backgroundColor = Styles.Colors.menuBackgroundColor.color
        dataSource = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        addMenuDoneButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func fetch(page: String?) {
        client.fetchRepositoryBranches(owner: owner,
                                 repo: repo,
                                 currentBranch: repoBranches.currentBranch
            )
        {  [weak self] result in
            switch result {
            case .success(let repoBranches):
                self?.repoBranches = repoBranches
            case .error:
                Squawk.showError(message: "Couldn't fetch repository branches")
            }
            self?.update(animated: true)
        }
    }
    
    func models(adapter: ListSwiftAdapter) -> [ListSwiftPair] {
        guard feed.status == .idle else { return [] }
        let selectedBranch = repoBranches.currentBranch
        
        return repoBranches.branches.map { branch in
            let value = RepositoryBranchViewModel(branch: branch,
                                                  selected: branch == selectedBranch)
            
            return ListSwiftPair(value) { [weak self] in
                let controller = RepositoryBranchSectionController()
                controller.delegate = self
                return controller
            }
        }
    }
    
    func didSelect(value: RepositoryBranchViewModel) {
        repoBranches = repoBranches.switchCurrentBranch(to: value.branch)
        fetch(page: nil)
    }
}
