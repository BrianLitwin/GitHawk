//
//  UIViewController+SearchIssuesForLabel.swift
//  Freetime
//
//  Created by B_Litwin on 10/14/18.
//  Copyright © 2018 Ryan Nystrom. All rights reserved.
//

import UIKit

extension UIViewController {

    func searchForLabelInRepositoryIssuesViewController(label: String) {
        if let issuesViewController = self as? IssuesViewController {
            guard let navController = issuesViewController.navigationController,
                navController.viewControllers.count > 1,
                let repositoryViewController = navController
                    .viewControllers[1] as? RepositoryViewController
                else { return }
            
//            repositoryViewController
//                .searchForLabelInRepositoryIssuesViewController(
//                label: label
//            )
            
            navController.viewControllers.popLast()
            
            
            // + scroll to top 
        }
    }
}

