//
//  TextField.swift
//  Caddy App
//
//  Created by Karl Cridland on 30/04/2021.
//

import Foundation
import UIKit

class TextField: UITextField {
    let inset: CGFloat = 10

    // placeholder position
    override func textRect(forBounds: CGRect) -> CGRect {
        return forBounds.insetBy(dx: self.inset, dy: self.inset)
    }

    // text position
    override func editingRect(forBounds: CGRect) -> CGRect {
        return forBounds.insetBy(dx: self.inset , dy: self.inset)
    }

    override func placeholderRect(forBounds: CGRect) -> CGRect {
        return forBounds.insetBy(dx: self.inset, dy: self.inset)
    }
}

