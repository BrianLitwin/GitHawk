//
//  SwitchBranches.swift
//  FreetimeTests
//
//  Created by B_Litwin on 9/28/18.
//  Copyright © 2018 Ryan Nystrom. All rights reserved.
//

import XCTest
@testable import Freetime
import GitHubAPI

class SwitchBranches: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }

    func test_V3ReadmeRequest() {
        let request = V3RepositoryReadmeRequest(owner: "githawkapp",
                                                repo: "githawk",
                                                branch: "master")
        
        let parameters = request.parameters as! [String: String]
        let expectedParams = ["ref": "master"]
        XCTAssertEqual(parameters, expectedParams)
    }
    
    func test_RepositoryBranchUpdatable() {
        
        let viewController = RepositoryViewController(client: newGithubClient(),
                                                      repo: RepositoryDetails(owner: "githawkapp",
                                                                              name: "githawk",
                                                                              defaultBranch: "master",
                                                                              hasIssuesEnabled: true))
        
        viewController.loadViewIfNeeded()
        let repositoryOverviewController = viewController
            .viewController(for: viewController, at: 0) as! RepositoryOverviewViewController
        let repositoryCodeDirectoryViewController = viewController
            .viewController(for: viewController, at: 3) as! RepositoryCodeDirectoryViewController
        
        var _ = repositoryOverviewController as RepositoryBranchUpdatable
        var _ = repositoryCodeDirectoryViewController as RepositoryBranchUpdatable
     
        
    }
    
    
    
}
