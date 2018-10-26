//
//  testTest.swift
//  FreetimeTests
//
//  Created by B_Litwin on 10/26/18.
//  Copyright © 2018 Ryan Nystrom. All rights reserved.
//

import XCTest
@testable import GitHubAPI
@testable import Freetime
import FlatCache
import Apollo

extension GithubClient {
    init(mockClient: Client) {
        self.userSession = nil
        self.cache = FlatCache()
        self.bookmarksStore = nil
        self.client = mockClient
        self.badge = BadgeNotifications(client: mockClient)
    }
}

class MockClient: Client {
    init() {
        let config = ConfiguredNetworkers(
            token: nil,
            useOauth: nil
        )
        super.init(
            httpPerformer: config.alamofire,
            apollo: config.apollo,
            token: nil
        )
    }
    
    override func send<T>(_ request: T, completion: @escaping (Result<T.ResponseType>) -> Void) where T : HTTPRequest {
        print("Seen")
    }
    
}

let githawkRepoDetails = RepositoryDetails(
    owner: "githawkapp",
    name: "githawk",
    defaultBranch: "master",
    hasIssuesEnabled: true
)



class testTest: XCTestCase {

    override func setUp() {
        
    }

    func test() {
        
        let cli = MockClient()
        let client = GithubClient(mockClient: cli)
        let repoDetails = RepositoryDetails(
            owner: "githawk",
            name: "githawkapp",
            defaultBranch: "master",
            hasIssuesEnabled: true
        )
        
        let repository = RepositoryOverviewViewController(
            client: client,
            repo: githawkRepoDetails
        )
        
        repository.fetch(page: nil)
        
    }

}
