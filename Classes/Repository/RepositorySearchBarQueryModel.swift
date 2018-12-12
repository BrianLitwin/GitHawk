//
//  RepositorySearchBarQueryModel.swift
//  Freetime
//
//  Created by B_Litwin on 12/12/18.
//  Copyright © 2018 Ryan Nystrom. All rights reserved.
//

import UIKit

struct RepositorySearchBarQueryModel {
    public private (set) var searchString = "is:open "
    private let baseQuery: String
    
    init(type: RepositoryIssuesType,
         repo: String,
         owner: String,
         label: String?
        ) {
        let typeQuery: String
        switch type {
            case .issues: typeQuery = "is:issue"
            case .pullRequests: typeQuery = "is:pr"
        }
        self.baseQuery = "repo:\(owner)/\(repo) \(typeQuery) "
        if let label = label {
            searchString += format(label: label)
        }
    }
    
    // MARK: Public API
    
    public var fullQueryString: String {
        return (baseQuery + searchString).lowercased()
    }
    
    public mutating func set(query: String) {
        self.searchString = query
    }
    
    public func queryFor(label: String) -> String {
        guard searchString.range(of: label) == nil else { return searchString }
        let labelQuery = format(label: label)
        return searchString.update(with: labelQuery)
    }
    
    // MARK: Private
    
    private func format(label: String) -> String {
        return "label:" + "\"" + label + "\""
    }
}

private let regex: NSRegularExpression = try! NSRegularExpression(pattern: "label:\"(.*?)\"", options: [])

private extension String {
    
    func update(with labelQuery: String) -> String {
        let matches = regex.matches(in: self, range: nsrange)
        guard !matches.isEmpty,
            let range = range(from: matches[0].range) else
        { return self + " " + labelQuery}
        return self.replacingCharacters(in: range, with: labelQuery)
    }
}
