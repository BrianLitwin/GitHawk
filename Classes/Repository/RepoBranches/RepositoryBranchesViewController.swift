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

protocol RepoBranchUpdateable: class {
    func updateRepoBranch(with repoBranches: RepoBranches)
}

final class RepoBranchesViewController: BaseListViewController2<String>,
BaseListViewController2DataSource,
RepoBranchSectionControllerDelegate
{

    private let owner: String
    private let repo: String
    private let client: GithubClient
    public var repoBranches: RepoBranches
    
    init(repoBranches: RepoBranches,
         owner: String,
         repo: String,
         client: GithubClient
        ){
        self.repoBranches = repoBranches
        self.owner = owner
        self.repo = repo
        self.client = client
        super.init(emptyErrorMessage: "Couldn't load branches")
        
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
        client.fetchRepoBranches(owner: owner,
                                 repo: repo,
                                 currentBranch: repoBranches.currentBranch
        ){  [weak self] result in
            switch result {
            case .success(let repoBranches):
                sleep(2)
                self?.repoBranches = repoBranches
            case .error:
                Squawk.showGenericError()
            }
            
            self?.update(animated: true)
        }
    }
    
    func models(adapter: ListSwiftAdapter) -> [ListSwiftPair] {
        guard feed.status == .idle else { return [] }
        let selectedBranch = repoBranches.currentBranch
        
        return repoBranches.branches.map { branch in
            let value = RepoBranchViewModel(branch: branch,
                                            selected: branch == selectedBranch)
            
            return ListSwiftPair(value) { [weak self] in
                let controller = RepoBranchSectionController()
                controller.delegate = self
                return controller
            }
        }
    }
    
    func didSelect(value: RepoBranchViewModel) {
        repoBranches = repoBranches.switchBranch(to: value.branch)
        fetch(page: nil)
    }
}
