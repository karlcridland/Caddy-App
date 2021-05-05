//
//  UIView.swift
//  Caddy App
//
//  Created by Karl Cridland on 30/04/2021.
//

import Foundation
import UIKit

extension UIView{
    func addShadow(_ opacity: Float, _ height: Int, _ radius: CGFloat) {
        self.layer.shadowColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1).cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = CGSize(width: 0, height: height)
        self.layer.shadowRadius = radius
    }
}

