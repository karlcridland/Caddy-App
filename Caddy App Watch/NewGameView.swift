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
    
    var scores = [Int:Int]()
    var currentRound: Int?
    
    init(frame: CGRect, location: String?) {
        self.location = location
        super .init(frame: frame)
        back.setTitleColor(.black, for: .normal)
        back.backgroundColor = #colorLiteral(red: 0, green: 0.9810667634, blue: 0.5736914277, alpha: 1)
        if let location = location{
            startGame(location)
        }
        else{
            selectCourse()
        }
        
    }
    
    // If a game is started without a location set, the player has to choose one from their saved locations - alternatively they can
    // choose to play a round without pars set. Method brings a view on to screen with all locations with the final option being no
    // course.
    
    func selectCourse(){
        let view = UIView(frame: CGRect(x: 0, y: self.back.frame.maxX+20, width: self.frame.width, height: self.frame.height-self.back.frame.maxX+20-Settings.bottom))
        self.addSubview(view)
        
        
    }
    
    // Once a location is selected, the game starts and all features (title, current hole, a scroll of all holes to change to, and the
    // game controls which change the score of the current hole and can move to the next hole).
    
    func startGame(_ location: String) {
        let controls = GameControls(frame: CGRect(x: 0, y: self.frame.height-100-Settings.bottom, width: self.frame.width, height: 100))
        self.addSubview(controls)
        
        let title = UILabel(frame: CGRect(x: self.back.frame.maxX+20, y: self.back.frame.minY, width: self.frame.width-self.back.frame.maxX-40, height: self.back.frame.height))
        title.text = location
        title.textAlignment = .right
        title.font = .systemFont(ofSize: 22, weight: UIFont.Weight(0.3))
        title.textColor = #colorLiteral(red: 0, green: 0.9810667634, blue: 0.5736914277, alpha: 1)
        self.addSubview(title)
        
        let currentHole = UIView(frame: CGRect(x: 0, y: self.back.frame.maxY+20, width: self.frame.width, height: 100))
        self.addSubview(currentHole)
        
        let allHoles = UIScrollView(frame: CGRect(x: 0, y: currentHole.frame.maxY, width: self.frame.width, height: controls.frame.minY-currentHole.frame.maxY))
        self.addSubview(allHoles)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
