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
        
        let view = UIScrollView(frame: CGRect(x: 10, y: title.frame.maxY, width: self.frame.width-20, height: self.frame.height-title.frame.maxY-Settings.bottom))
        self.addSubview(view)
        view.backgroundColor = .black.withAlphaComponent(0.8)
        view.layer.cornerRadius = 12
        
        let chooseHoles = UISegmentedControl(items: ["9 Holes", "18 Holes"])
        chooseHoles.frame = CGRect(x: self.back.frame.maxX+20, y: self.back.frame.minY - 1, width: self.frame.width - self.back.frame.maxX - 40, height: self.back.frame.height + 2)
        chooseHoles.addTarget(self, action: #selector(holesClicked), for: .valueChanged)
        chooseHoles.selectedSegmentIndex = 0
        chooseHoles.selectedSegmentTintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        chooseHoles.backgroundColor = .white
        chooseHoles.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: UIFont.Weight(0.3))], for: .normal)
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        UISegmentedControl.appearance().setTitleTextAttributes(titleTextAttributes, for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes(titleTextAttributes, for: .normal)
        self.addSubview(chooseHoles)
        
        func appendOption(_ option: String?, _ y: CGFloat) -> UIView{
            let optionView = UIView(frame: CGRect(x: 10, y: y+10, width: view.frame.width-20, height: 50))
            let label = UILabel(frame: CGRect(x: 20, y: 0, width: optionView.frame.width-40, height: optionView.frame.height))
            label.font = .systemFont(ofSize: 18, weight: UIFont.Weight(rawValue: 0.3))
            optionView.addSubview(label)
            label.text = "Play Without Course"
            if let option = option{
                label.text = option
            }
            view.addSubview(optionView)
            view.contentSize = CGSize(width: 0, height: optionView.frame.maxY)
            optionView.selectable()
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: optionView.frame.width, height: optionView.frame.height))
            optionView.addSubview(button)
            button.accessibilityLabel = option
            button.addTarget(self, action: #selector(locationClicked), for: .touchUpInside)
            return optionView
        }
        
        if let locations = Settings.storage["location"]{
            locations.enumerated().forEach { (i, location) in
                let _ = appendOption(location, CGFloat(i)*60)
            }
        }
        let without = appendOption(nil, view.contentSize.height+10)
        
        if (without.frame.maxY+10 < view.frame.height){
            view.frame = CGRect(x: 10, y: title.frame.maxY, width: self.frame.width-20, height: without.frame.maxY+10)
        }
        
    }
    
    // Changes the value of the hole selection, allowing the user to choose between 9 or 18 holes.
    
    @objc func holesClicked(sender: UISegmentedControl){
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        if (sender.selectedSegmentIndex == 0){
            numberOfHoles = 9
        }
        else{
            numberOfHoles = 18
        }
        print(numberOfHoles)
    }
    
    @objc func locationClicked(sender: UIButton){
        if let location = sender.accessibilityLabel{
            startGame(location)
        }
        else{
            startGame(nil)
        }
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
        
        title.text = "New Game"
        if let location = location{
            title.text = location
        }
        
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
            
            let holelabel = UILabel(frame: CGRect(x: 20, y: 0, width: width, height: holeBackground.frame.height))
            holelabel.text = "Hole \(i)"
            holeBackground.addSubview(holelabel)
            holelabel.font = .systemFont(ofSize: 16, weight: UIFont.Weight(0.3))
            
            if let location = location{
                if let par = Settings.holes[location]{
                    let parLabel = UILabel(frame: CGRect(x: 20+width, y: 0, width: width, height: holeBackground.frame.height))
                    parLabel.text = "PAR \(par[i-1])"
                    holeBackground.addSubview(parLabel)
                    parLabel.font = .systemFont(ofSize: 16, weight: UIFont.Weight(0.3))
                }
            }
            
            let overUnder = UILabel(frame: CGRect(x: 20+(2*width), y: 0, width: width, height: holeBackground.frame.height))
            holeBackground.addSubview(overUnder)
            overUnder.font = .systemFont(ofSize: 16, weight: UIFont.Weight(0.3))
            overUnders[i] = overUnder
            
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

private extension UIView{
    func selectable() {
        self.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1).withAlphaComponent(0.4)
        self.layer.borderWidth = 3
        self.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.layer.cornerRadius = 6
        self.addShadow(0.1, 2, 7)
        self.layer.shadowColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
}
