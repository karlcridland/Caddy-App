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
    var numberOfHoles = 9
    var overUnders = [Int:UILabel]()
    var holeScores = [Int:UILabel]()
    let controls: GameControls
    
    init(frame: CGRect, location: String?) {
        self.location = location
        self.controls = GameControls(frame: CGRect(x: 0, y: frame.height-100-Settings.bottom, width: frame.width, height: 100))
        super .init(frame: frame)
        self.back.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).withAlphaComponent(0.8), for: .normal)
        self.back.backgroundColor = #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)
        self.back.layer.borderColor = #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1).withAlphaComponent(0.3).cgColor
        self.back.layer.borderWidth = 3
        if let location = location{
            self.startGame(location)
        }
        else{
            self.selectCourse()
        }
        self.back.addTarget(self, action: #selector(resetLocation), for: .touchUpInside)
        
    }
    
    // If a game is started without a location set, the player has to choose one from their saved locations - alternatively they can
    // choose to play a round without pars set. Method brings a view on to screen with all locations with the final option being no
    // course.
    
    func selectCourse(){
        
        let title = UILabel(frame: CGRect(x: 20, y: self.back.frame.maxY+20, width: self.frame.width-40, height: 60))
        title.font = .systemFont(ofSize: 20, weight: UIFont.Weight(rawValue: 0.3))
        title.text = "Select the course you're playing:"
        self.addSubview(title)
        
        let choose = ChooseLocation(frame: CGRect(x: 10, y: title.frame.maxY, width: self.frame.width-20, height: self.frame.height-title.frame.maxY-Settings.bottom), newGameView: self)
        self.addSubview(choose)
        
    }
    
    // Once a location is selected, the game starts and all features (title, current hole, a scroll of all holes to change to, and the
    // game controls which change the score of the current hole and can move to the next hole).
    
    func startGame(_ location: String?) {
        self.subviews.forEach { subview in
            subview.removeFromSuperview()
        }
        self.addSubview(self.back)
        self.addSubview(controls)
        
        let titleWidth = self.frame.width-self.back.frame.maxX-40
        let title = UILabel(frame: CGRect(x: self.back.frame.maxX+20, y: self.back.frame.minY, width: titleWidth, height: self.back.frame.height))
        title.textAlignment = .right
        title.font = .systemFont(ofSize: 22, weight: UIFont.Weight(0.3))
        title.textColor = .white
        self.addSubview(title)
        
        title.text = location ?? "New Game"
        
        let currentHole = CurrentHole(frame: CGRect(x: 0, y: self.back.frame.maxY+20, width: self.frame.width, height: 60))
        self.addSubview(currentHole)
        
        let allHoles = UIScrollView(frame: CGRect(x: 0, y: currentHole.frame.maxY, width: self.frame.width, height: controls.frame.minY-currentHole.frame.maxY))
        self.addSubview(allHoles)
        allHoles.backgroundColor = .black
        
        for i in 1 ... numberOfHoles{
            let holeBackground = UIView(frame: CGRect(x: 10, y: CGFloat(i-1)*60+10, width: allHoles.frame.width-20, height: 50))
            allHoles.addSubview(holeBackground)
            holeBackground.layer.cornerRadius = 8
            holeBackground.layer.backgroundColor = #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1)
            allHoles.contentSize = CGSize(width: allHoles.frame.width, height: holeBackground.frame.maxY+10)
            
            let width = (holeBackground.frame.width-40)/4
            
            func addLabel(_ x: CGFloat) -> UILabel{
                let label = UILabel(frame: CGRect(x: x, y: 0, width: width, height: holeBackground.frame.height))
                holeBackground.addSubview(label)
                label.font = .systemFont(ofSize: 16, weight: UIFont.Weight(0.3))
                return label
            }
            
            let holelabel = addLabel(20)
            holelabel.text = "Hole \(i)"
            
            if let location = location{
                if let par = Settings.holes[location]{
                    let parLabel = addLabel(20+width)
                    parLabel.text = "PAR \(par[i-1])"
                }
            }
            
            let overUnder = addLabel(20+(2*width))
            self.overUnders[i] = overUnder
            
            let holeScore = addLabel(20+(3*width))
            self.holeScores[i] = holeScore
            holeScore.textAlignment = .right
            holeScore.text = "0"
        }
        
        currentHole.updateHole(1, nil)
    }
    
    @objc func resetLocation(){
        location = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
