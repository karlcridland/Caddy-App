//
//  InterfaceController.swift
//  Caddy App Watch WatchKit Extension
//
//  Created by Karl Cridland on 01/05/2021.
//

import WatchKit
import Foundation


class HolePickerController: WKInterfaceController {
    
    @IBOutlet var prompt: WKInterfaceLabel!
    @IBOutlet var holePicker: WKInterfaceTable!
    
    override func awake(withContext context: Any?) {
        // Configure interface objects here.
        Settings.prompt = prompt
        Settings.holePicker = holePicker
        
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
    }

    @IBAction func holeClicked(sender: WKInterfaceButton) {
        print(2)
        if let n = Settings.buttons.firstIndex(where: {$0 == sender}){
            print(n)
        }
    }
}
