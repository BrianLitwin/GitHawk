//
//  String+RepositoryLink.swift
//  Freetime
//
//  Created by B_Litwin on 10/23/18.
//  Copyright © 2018 Ryan Nystrom. All rights reserved.
//

import Foundation 

private let gitHubRepoRegex = try! NSRegularExpression (
    pattern: "https:\\/\\/github.com\\/([^/]+)\\/([^/]+)\\/?$",
    options: []
)
extension String {
    var repositoryLink: (owner: String, name: String)? {
        guard let match = gitHubRepoRegex.firstMatch(in: self, options: [], range: nsrange),
            match.numberOfRanges > 1,
            let ownerSubstring = substring(with: match.range(at: 1)),
            let repoSubstring = substring(with: match.range(at: 2))
            else { return nil }
        return (ownerSubstring, repoSubstring)
    }
}
