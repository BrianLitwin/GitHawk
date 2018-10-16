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

    func searchForLabelInRepositoryIssuesViewController(label: String) {
        
        func fallbackRequest() {
            //guard let url = URL(string: "https://github.com/\(owner)/\(repo)/labels/\(label)") else { return }
            //presentSafari(url: url)
        }
        
        guard let navController = navigationController,
            let repositoryViewController =
            navController.repositoryViewController,
            let repositoryIssuesViewController =
            repositoryViewController.viewController(
                for: repositoryViewController,
                at: 1
            ) as? RepositoryIssuesViewController else
        {
            fallbackRequest()
            return
        }
        
        repositoryViewController.scrollToPage(
            .at(index: 1),
            animated: false
        )
        
        navController.popToViewController(
            repositoryViewController,
            animated: true
        )
        
        repositoryIssuesViewController
            .searchIssuesForLabel(label)
        
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

