//
//  HelperExtension.swift
//  Instagrid
//
//  Created by Nathan on 05/02/2020.
//  Copyright © 2020 Nathan. All rights reserved.
//

import UIKit

// Silence breaking constraint when displaying alert controller
extension UIAlertController {
    func pruneNegativeWidthConstraints() {
        for subView in view.subviews {
            for constraint in subView.constraints where constraint.debugDescription.contains("width == - 16") {
                subView.removeConstraint(constraint)
            }
        }
    }
}
