//
//  StatisticsView.swift
//  Caddy App Watch
//
//  Created by Karl Cridland on 17/05/2021.
//

import Foundation
import UIKit

class StatisticsView: ScreenView{
    
    let dropdown: DropdownView
    
    override init(frame: CGRect) {
        self.dropdown = DropdownView(frame: CGRect(x: 120, y: 20, width: UIScreen.main.bounds.width - 140, height: 40), choices: nil, placeholder: "choose location")
        super .init(frame: frame)
        
        self.addSubview(self.dropdown)
        self.dropdown.updateChoices(Settings.storage["location"])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
