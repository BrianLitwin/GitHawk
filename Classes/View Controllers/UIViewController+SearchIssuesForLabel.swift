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
        print(label)
        if let o = self as? IssuesViewController {
            o.dismiss?(label)
            // + scroll to top 
        }
    }
    
}

