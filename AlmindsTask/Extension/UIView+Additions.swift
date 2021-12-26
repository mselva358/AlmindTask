//
//  UIView+Additions.swift
//  AlmindsTask
//
//  Created by Admin on 12/26/21.
//

import UIKit

extension UIView {

    @IBInspectable var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
        }
    }

}
