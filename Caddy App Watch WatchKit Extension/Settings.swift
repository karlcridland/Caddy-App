//
//  Settings.swift
//  Caddy App Watch WatchKit Extension
//
//  Created by Karl Cridland on 01/05/2021.
//

import Foundation
import WatchKit

class Settings {
    static var interface: InterfaceController?
    static var prompt: WKInterfaceLabel?
    static var holePicker: WKInterfaceTable?
    static var buttons = [WKInterfaceButton]()
    static var playing = false
}
