//
//  RepositoryURLTests.swift
//  FreetimeTests
//
//  Created by B_Litwin on 10/23/18.
//  Copyright © 2018 Ryan Nystrom. All rights reserved.
//

import XCTest
@testable import Freetime

class RepositoryURLTests: XCTestCase {
    
    var url: String!
    var result: (owner: String, name: String)? {
        guard let repo = url.repositoryLink else { return nil }
        return (repo.owner, repo.name)
    }
    
    func test_repositoryURL_positiveMatches() {
        
        url = "https://github.com/GitHawkApp/GitHawk"
        XCTAssertEqual(result!.owner, "GitHawkApp")
        XCTAssertEqual(result!.name, "GitHawk")
        
        url = "https://github.com/GitHawkApp/GitHawk/"
        XCTAssertEqual(result!.owner, "GitHawkApp")
        XCTAssertEqual(result!.name, "GitHawk")
        
    }
    
    func test_repositoryURL_negativeMatches() {
        
        url = "https://github.com/GitHawkApp"
        XCTAssertNil(result)
        
        url = "https://github.com/GitHawkApp/"
        XCTAssertNil(result)
        
        url = "https://github.com/GitHawkApp/GitHawk/issues"
        XCTAssertNil(result)
        
        url = "https://github.com/GitHawkApp/GitHawk/issues/45"
        XCTAssertNil(result)
        
        url = "https://developer.github.com/v4/guides/"
        XCTAssertNil(result)
    }
}
