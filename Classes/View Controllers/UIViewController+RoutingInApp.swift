//
//  UIViewController+RoutingInApp.swift
//  Freetime
//
//  Created by B_Litwin on 10/17/18.
//  Copyright © 2018 Ryan Nystrom. All rights reserved.
//

import UIKit
import GitHubAPI

extension UIViewController {
    
    func presentLabels(label: LabelDetails)
    {
        let repositoryIssuesViewController =
            RepositoryIssuesViewController(
                client: label.client,
                owner: label.owner,
                repo: label.repo,
                type: .issues,
                label: label.label
            )
        
        navigationController?.pushViewController(
            repositoryIssuesViewController,
            animated: trueUnlessReduceMotionEnabled
        )
    }
}
