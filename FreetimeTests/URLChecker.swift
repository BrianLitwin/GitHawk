
//
//  URLChecker.swift
//  FreetimeTests
//
//  Created by B_Litwin on 10/11/18.
//  Copyright © 2018 Ryan Nystrom. All rights reserved.
//

import XCTest
@testable import Freetime

class URLChecker: XCTestCase {
    
    var url: String!
    var expected: RouteFromURL!
    
    var result: RouteFromURL? {
        return routeInAppFromGitHubURL(url: url)
    }
    
    func test_urlParts_PositiveMatches_ForIssues() {
        
        url = "https://github.com/GitHawkApp/GitHawk/issues/2274"
        expected = RouteFromURL.issue(
            owner: "GitHawkApp",
            repo: "GitHawk",
            number: 2274
        )
        
        XCTAssertEqual(result, expected)
        
    }
    
    func test_urlParts_PositiveMatches_ForRepositories() {
        
        url = "https://github.com/GitHawkApp/GitHawk"
        expected = RouteFromURL.repository(
            owner: "GitHawkApp",
            repo: "GitHawk"
        )
        
        XCTAssertEqual(result, expected)
        
        //adding a "/" to the end
        url = "https://github.com/GitHawkApp/GitHawk/"
        expected = RouteFromURL.repository(
            owner: "GitHawkApp",
            repo: "GitHawk"
        )
        
        XCTAssertEqual(result, expected)
        
    }
    
    func test_urlParts_NegativeMatches() {
        
        url = "https://github.com"
        XCTAssertNil(result)
        
        url = "https://github.com/githawkapp"
        XCTAssertNil(result)
        
        //adding a '/' at the end
        url = "https://github.com/githawkapp/"
        XCTAssertNil(result)
        
        
        
    }
    
}

extension RouteFromURL: Equatable {
    
    public static func == (lhs: RouteFromURL, rhs: RouteFromURL) -> Bool {
        switch lhs {
        case .issue(let owner, let repo, let number):
            guard case let .issue(rhsOwner, rhsRepo, rhsNumber) = rhs else {
                return false
            }
            
            return owner == rhsOwner
                && repo == rhsRepo
                && number == rhsNumber
            
        case .repository(let owner, let repo):
            guard case let .repository(rhsOwner, rhsRepo) = rhs else {
                return false
            }
            
            return owner == rhsOwner
                && repo == rhsRepo
        }
    }
}



