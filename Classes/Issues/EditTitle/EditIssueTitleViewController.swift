//
//  EditIssueTitleViewController.swift
//  Freetime
//
//  Created by B_Litwin on 1/5/19.
//  Copyright © 2019 Ryan Nystrom. All rights reserved.
//

import UIKit
import GitHubAPI
import SnapKit
import Squawk

final class EditIssueTitleViewController: UIViewController {
    
    private let issueTitle: String
    private let textView = UITextView()
    public private(set) var editedIssueTitle: String?
    
    init(issueTitle: String) {
        self.issueTitle = issueTitle
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        preferredContentSize = CGSize(
            width: Styles.Sizes.contextMenuSize.width,
            height: 120
        )
        title = Constants.Strings.edit
        
        view.addSubview(textView)
        textView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
        textView.textContainerInset = Styles.Sizes.textViewInset
        textView.text = issueTitle
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: Constants.Strings.save,
            style: .plain,
            target: self,
            action: #selector(
                EditIssueTitleViewController.onSave
            )
        )
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: Constants.Strings.cancel,
            style: .plain,
            target: self,
            action: #selector(
                EditIssueTitleViewController.onCancel
            )
        )
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textView.becomeFirstResponder()
    }
    
    @objc func onSave() {
        textView.resignFirstResponder()
        if textView.text != issueTitle {
            editedIssueTitle = textView.text
        }
        dismiss(animated: true)
    }
    
    @objc func onCancel() {
        textView.resignFirstResponder()
        dismiss(animated: true)
    }
}