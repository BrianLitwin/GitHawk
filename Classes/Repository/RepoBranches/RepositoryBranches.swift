//
//  RepoBranches.swift
//  Freetime
//
//  Created by B_Litwin on 9/25/18.
//  Copyright © 2018 Ryan Nystrom. All rights reserved.
//

import UIKit


struct RepositoryBranches: Equatable {
    public let branches: [String]
    public let currentBranch: String
    
    func switchBranch(to newBranch: String) -> RepositoryBranches {
        return RepoBranches(branches: self.branches,
                            currentBranch: newBranch
        )
    }
    
    static func == (lhs: RepositoryBranches, rhs: RepositoryBranches) -> Bool {
        return lhs.branches == rhs.branches
        && lhs.currentBranch == rhs.currentBranch
    }
}

