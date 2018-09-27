//
//  RepoBranches.swift
//  Freetime
//
//  Created by B_Litwin on 9/25/18.
//  Copyright © 2018 Ryan Nystrom. All rights reserved.
//

import UIKit


struct RepoBranches: Equatable {
    public let branches: [String]
    public let currentBranch: String
    
    func switchBranch(to newBranch: String) -> RepoBranches {
        return RepoBranches(branches: self.branches,
                            currentBranch: newBranch
        )
    }
    
    static func == (lhs: RepoBranches, rhs: RepoBranches) -> Bool {
        return lhs.branches == rhs.branches
        && lhs.currentBranch == rhs.currentBranch
    }
}

