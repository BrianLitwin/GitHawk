//
//  UIViewController+SearchIssuesForLabel.swift
//  Freetime
//
//  Created by B_Litwin on 10/14/18.
//  Copyright © 2018 Ryan Nystrom. All rights reserved.
//

import UIKit

// one way direction of data flow 

// set the text in the search bar
// fetch(page:)
//

extension UIViewController {

    func searchForLabelInIssues(label: LabelDetails) {
        
        func fallbackRequest() {
            guard let url = URL(
                string: "https://github.com/\(label.owner)/\(label.repo)/labels/\(label)"
            ) else { return }
            presentSafari(url: url)
        }
        
        guard let navController = navigationController,
            let repositoryViewController =
            navController.repositoryViewController,
            let repositoryIssuesViewController =
            repositoryViewController.repositoryIssuesViewController
            else
        {
            fallbackRequest()
            return
        }
        
        repositoryViewController
            .scrollToRepositoryIssuesViewController()
        
        navController.popToViewController(
            repositoryViewController,
            animated: true
        )
        
        repositoryIssuesViewController
            .searchIssuesForLabel(label.label)
        
    }
}


private extension RepositoryViewController {
    
    var repositoryIssuesViewController: RepositoryIssuesViewController? {
        return viewController(
            for: self,
            at: 1
        ) as? RepositoryIssuesViewController
    }
    
    func scrollToRepositoryIssuesViewController() {
        scrollToPage(
            .at(index: 1),
            animated: false
        )
    }
}


private extension UINavigationController {
    var repositoryViewController: RepositoryViewController? {
        for vc in viewControllers {
            if let repositoryViewController = vc as? RepositoryViewController {
                return repositoryViewController
            }
        }
        
        return nil
    }
}

