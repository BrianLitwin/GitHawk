//
//  RepositoryLink.swift
//  Freetime
//
//  Created by B_Litwin on 10/14/18.
//  Copyright © 2018 Ryan Nystrom. All rights reserved.
//

import UIKit

// for when we catch a repository link in markdown and want to route to it in-app

struct RepositoryLink {
    let owner: String
    let name: String
    let url: String // keep as a fallback in case showing repo in GitHawk fails
}

