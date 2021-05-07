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
        self.back.setTitleColor(.black, for: .normal)
        self.back.backgroundColor = #colorLiteral(red: 0, green: 0.9810667634, blue: 0.5736914277, alpha: 1)
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
        title.text = "Select the course you're playing at:"
        self.addSubview(title)
        
        let view = UIScrollView(frame: CGRect(x: 10, y: title.frame.maxY, width: self.frame.width-20, height: self.frame.height-title.frame.maxY-Settings.bottom))
        self.addSubview(view)
        view.backgroundColor = .black.withAlphaComponent(0.4)
        view.layer.cornerRadius = 12
        
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
        let controls = GameControls(frame: CGRect(x: 0, y: self.frame.height-100-Settings.bottom, width: self.frame.width, height: 100))
        self.addSubview(controls)
        
        let titleWidth = self.frame.width-self.back.frame.maxX-40
        let title = UILabel(frame: CGRect(x: self.back.frame.maxX+20, y: self.back.frame.minY, width: titleWidth, height: self.back.frame.height))
        title.textAlignment = .right
        title.font = .systemFont(ofSize: 22, weight: UIFont.Weight(0.3))
        title.textColor = #colorLiteral(red: 0, green: 0.9810667634, blue: 0.5736914277, alpha: 1)
        self.addSubview(title)
        
        title.text = "New Game"
        if let location = location{
            title.text = location
        }
        
        let currentHole = CurrentHole(frame: CGRect(x: 0, y: self.back.frame.maxY+20, width: self.frame.width, height: 60))
        self.addSubview(currentHole)
        
        let allHoles = UIScrollView(frame: CGRect(x: 0, y: currentHole.frame.maxY, width: self.frame.width, height: controls.frame.minY-currentHole.frame.maxY))
        self.addSubview(allHoles)
        
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
        self.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        self.layer.borderWidth = 3
        self.layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        self.layer.cornerRadius = 6
    }
}
