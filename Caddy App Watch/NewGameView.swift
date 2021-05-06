//
//  NewGameView.swift
//  Caddy App Watch
//
//  Created by Karl Cridland on 02/05/2021.
//

import Foundation
import UIKit

class NewGameView: ScreenView {
    
    var location: String?
    let locationPicker = UIScrollView()
    
    init(frame: CGRect, location: String?) {
        self.location = location
        super .init(frame: frame)
        
        if let location = location{
            startGame(location)
        }
        else{
            
        }
        
    }
    
    func startGame(_ location: String) {
        let controls = GameControls(frame: CGRect(x: 0, y: self.frame.height-100, width: self.frame.width, height: 100))
        self.addSubview(controls)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
