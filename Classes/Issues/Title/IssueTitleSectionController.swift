//
//  IssueTitleSectionController.swift
//  Freetime
//
//  Created by Ryan Nystrom on 5/19/17.
//  Copyright © 2017 Ryan Nystrom. All rights reserved.
//

import UIKit
import IGListKit
import GitHubAPI
import ContextMenu

protocol IssueTitleSectionControllerDelegate: class {
    func sendEditTitleRequest(title: String)
}

final class IssueTitleSectionController: ListSectionController, ContextMenuDelegate {

    var object: IssueTitleModel?
    weak var delegate: IssueTitleSectionControllerDelegate?

    init(delegate: IssueTitleSectionControllerDelegate) {
        super.init()
        self.delegate = delegate
        inset = UIEdgeInsets(top: Styles.Sizes.rowSpacing, left: 0, bottom: 0, right: 0)
    }

    override func didUpdate(to object: Any) {
        guard let object = object as? IssueTitleModel else { return }
        self.object = object
    }

    override func sizeForItem(at index: Int) -> CGSize {
        guard let width = collectionContext?.insetContainerSize.width
            else { fatalError("Collection context must be set") }
        return CGSize(width: width, height: self.object?.string.viewSize(in: width).height ?? 0)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let object = self.object,
            let cell = collectionContext?.dequeueReusableCell(of: IssueTitleCell.self, for: self, at: index) as? IssueTitleCell
            else { fatalError("Collection context must be set, missing object, or cell incorrect type") }
        cell.set(renderer: object.string)
        return cell
    }
    
    override func didSelectItem(at index: Int) {
        guard let object = self.object else { return }
        editIssueTitle(title: object.string.string.allText)
//        let title = "Update Date in Workout History after changing it in workout"
//        delegate?.sendEditTitleRequest(title: title)
    }
    
    func editIssueTitle(title: String) {
        guard let sourceViewController = self.viewController else { return }
        let viewController = EditIssueTitleViewController(title: title)
        ContextMenu.shared.show(
            sourceViewController: sourceViewController,
            viewController: viewController,
            options: ContextMenu.Options(
                containerStyle: ContextMenu.ContainerStyle(
                    backgroundColor: Styles.Colors.menuBackgroundColor.color
                )
            )
        )
    }

    // MARK: ContextMenuDelegate
    
    func contextMenuWillDismiss(viewController: UIViewController, animated: Bool) {
        guard let viewController = viewController as? EditIssueTitleViewController else {
            return
        }
        
        
    }
    
    func contextMenuDidDismiss(viewController: UIViewController, animated: Bool) { }
    
}

// issueManagingSectionController
// save spins during network request


class EditIssueTitleViewController: UIViewController {
    
    let originalTitle: String
    
    init(title: String) {
        self.originalTitle = title
        super.init(nibName: nil, bundle: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let textView = UITextView()
        view.addSubview(textView)
        textView.text = title
        let font = Styles.Text.body.preferredFont
        textView.font = font
        let textSize = originalTitle.size(font: font)
        textView.frame = CGRect(
            x: 0,
            y: 0,
            width: textSize.width,
            height: textSize.height
        )
        
        preferredContentSize = CGSize(width: 200, height: 200)
        
        view.backgroundColor = .green
        title = "Edit"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: NSLocalizedString("Save", comment: ""),
            style: .plain,
            target: self,
            action: #selector(onMenuCancel)
        )
        navigationItem.rightBarButtonItem?.tintColor = Styles.Colors.Gray.light.color
  
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: Constants.Strings.cancel,
            style: .plain,
            target: self,
            action: #selector(onMenuCancel)
        )
        navigationItem.leftBarButtonItem?.tintColor = Styles.Colors.Gray.light.color
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
    }
    
    @objc func onMenuCancel() {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
