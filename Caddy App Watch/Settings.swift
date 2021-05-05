//
//  Settings.swift
//  Caddy App
//
//  Created by Karl Cridland on 30/04/2021.
//

import Foundation
import UIKit

class Settings {
    
    static var top = CGFloat(0)
    static var bottom = CGFloat(0)
    static var playing = false
    static var viewController: ViewController?
    static var cornerRadius = CGFloat(32)
    static var saving = false
    
    private let defaults = UserDefaults.standard
    
    public static let shared = Settings()
    
    static var storage = [String:[String]]()
    static var holes = [String:[Int]]()
    
    private init(){}
    
    func loadStorage() {
        if let storage = defaults.value(forKey: "storage") as? [String:[String]]{
            Settings.storage = storage
        }
        if let holes = defaults.value(forKey: "holes") as? [String:[Int]]{
            Settings.holes = holes
        }
    }
    
    @objc func save(){
        defaults.setValue(Settings.storage, forKey: "storage")
        defaults.setValue(Settings.holes, forKey: "holes")
    }
    
}
