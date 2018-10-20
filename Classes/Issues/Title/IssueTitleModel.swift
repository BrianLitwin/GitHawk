//
//  IssueTitleModel.swift
//  Freetime
//
//  Created by Ryan Nystrom on 1/13/18.
//  Copyright © 2018 Ryan Nystrom. All rights reserved.
//

import Foundation
import IGListKit
import StyledTextKit

final class IssueTitleModel: ListDiffable {

    let string: StyledTextRenderer
    let viewerCanUpdate: Bool

    init(string: StyledTextRenderer, viewerCanUpdate: Bool
    ) {
        self.string = string
        self.viewerCanUpdate = viewerCanUpdate
    }

    // MARK: ListDiffable

    func diffIdentifier() -> NSObjectProtocol {
        return string.string.hashValue as NSObjectProtocol
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        if self === object { return true }
        guard object is IssueTitleModel else { return false }
        return true
    }

}
