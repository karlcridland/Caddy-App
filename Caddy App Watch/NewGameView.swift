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
    var holeLabels = [Int:UILabel]()
    var holePars = [Int:UILabel]()
    var overUnders = [Int:UILabel]()
    var holeScores = [Int:UILabel]()
    let controls: GameControls
    var currentHole: CurrentHole?
    
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
        self.setUpButtons()
    }
    
    // Functionality for the buttons, the same method is used to increase or decrease the score of a round, the tag indicates whether
    // the button adds or removes a point, score is set to be zero or above. Next round sets the score to zero if one isn't present.
    
    func setUpButtons(){
        controls.decrease.addTarget(self, action: #selector(changeScore), for: .touchUpInside)
        controls.increase.addTarget(self, action: #selector(changeScore), for: .touchUpInside)
        controls.decrease.tag = -1
        controls.increase.tag = 1
        controls.nextHole.addTarget(self, action: #selector(nextRound), for: .touchUpInside)
    }
    
    @objc func changeScore(sender: UIButton){
        if let currentRound = currentRound{
            if let score = scores[currentRound]{
                var newScore = score+sender.tag
                if (newScore < 0){
                    newScore = 0
                }
                scores[currentRound] = newScore
            }
            else{
                if (sender.tag == 1){
                    scores[currentRound] = sender.tag
                }
            }
        }
        updateHoles()
    }
    
    @objc func nextRound(){
        if let round = currentRound, let score = scores[round], score == 0{
            return
        }
        if let currentRound = currentRound{
            self.currentRound = currentRound+1
            if (self.currentRound! > numberOfHoles){
                self.currentRound = numberOfHoles
                self.gameOver()
                return
            }
        }
        else{
            currentRound = 1
        }
        if scores[currentRound!] == nil{
            scores[currentRound!] = 0
        }
        updateHoles()
        updateColors()
    }
    
    // Display shows when the game is finished and all holes have been played.
    
    func gameOver() {
        self.clearScreen()
        let gameOverScreen = GameOver(frame: CGRect(x: 0, y: self.back.frame.maxY+20, width: self.frame.width, height: self.frame.height-self.back.frame.maxY-60-Settings.bottom), course: location, scores: scores, newGameView: self)
        self.addSubview(gameOverScreen)
    }
    
    // Methods retrieve all labels associated with a hole in the all holes section and change the color of the
    // row accordingly.
    
    private func updateColors(){
        for i in 1 ... numberOfHoles{
            if let _ = scores[i]{
                labelsForHole(i)?.forEach({ label in
                    label.textColor = .white
                })
            }
            else{
                labelsForHole(i)?.forEach({ label in
                    label.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
                })
            }
        }
        if let round = currentRound{
            labelsForHole(round)?.forEach({ label in
                label.textColor = #colorLiteral(red: 0, green: 0.9810667634, blue: 0.5736914277, alpha: 1)
            })
        }
    }
    
    private func labelsForHole(_ hole: Int) -> [UILabel]? {
        if let a = holeLabels[hole]{
            if let b = holePars[hole]{
                if let c = overUnders[hole]{
                    if let d = holeScores[hole]{
                        return [a,b,c,d]
                    }
                }
            }
        }
        return nil
    }
    
    // Method updates all the scores in the all holes section and also updates the current hole section.
    
    func updateHoles() {
        scores.enumerated().forEach { (i,value) in
            if let score = scores[i+1]{
                holeScores[i+1]?.text = String(score)
            }
        }
        if let currentHole = self.currentHole{
            if let round = currentRound{
                currentHole.updateHole(round, scores[round])
            }
        }
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
        self.clearScreen()
        self.addSubview(controls)
        
        let titleWidth = self.frame.width-self.back.frame.maxX-40
        let title = UILabel(frame: CGRect(x: self.back.frame.maxX+20, y: self.back.frame.minY, width: titleWidth, height: self.back.frame.height))
        title.textAlignment = .right
        title.font = .systemFont(ofSize: 22, weight: UIFont.Weight(0.3))
        title.textColor = .white
        self.addSubview(title)
        
        title.text = location ?? "New Game"
        
        currentHole = CurrentHole(frame: CGRect(x: 0, y: self.back.frame.maxY+20, width: self.frame.width, height: 60))
        if let currentHole = self.currentHole{
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
                holeLabels[i] = holelabel
                
                if let location = location{
                    if let par = Settings.holes[location]{
                        let parLabel = addLabel(20+width)
                        parLabel.text = "PAR \(par[i-1])"
                        holePars[i] = parLabel
                    }
                }
                
                let overUnder = addLabel(20+(2*width))
                self.overUnders[i] = overUnder
                
                let holeScore = addLabel(20+(3*width))
                self.holeScores[i] = holeScore
                holeScore.textAlignment = .right
                holeScore.text = "0"
                
                let button = UIButton(frame: CGRect(x: 0, y: 0, width: holeBackground.frame.width, height: holeBackground.frame.height))
                holeBackground.addSubview(button)
                button.addTarget(self, action: #selector(holeButtonClicked), for: .touchUpInside)
                button.tag = i
            }
            
            currentHole.updateHole(1, nil)
            
        }
        self.nextRound()
    }
    
    @objc func holeButtonClicked(sender: UIButton){
        if let _ = scores[sender.tag]{
            currentRound = sender.tag-1
            self.nextRound()
        }
    }
    
    @objc func resetLocation(){
        location = nil
    }
    
    // Function removes everything on the screen except for the back button.s
    
    func clearScreen(){
        self.subviews.forEach { subview in
            subview.removeFromSuperview()
        }
        self.addSubview(self.back)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
