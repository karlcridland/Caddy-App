//
//  ChooseLocation.swift
//  Caddy App Watch
//
//  Created by Karl Cridland on 10/05/2021.
//

import Foundation
import UIKit

class ChooseLocation: UIScrollView {
    
    let newGameView: NewGameView
    
    init(frame: CGRect, newGameView: NewGameView) {
        self.newGameView = newGameView
        super .init(frame: frame)
        
        newGameView.addSubview(self)
        self.backgroundColor = .black.withAlphaComponent(0.8)
        self.layer.cornerRadius = 12
        
        let chooseHoles = UISegmentedControl(items: ["9 Holes", "18 Holes"])
        chooseHoles.frame = CGRect(x: newGameView.back.frame.maxX+20, y: newGameView.back.frame.minY - 1, width: newGameView.frame.width - newGameView.back.frame.maxX - 40, height: newGameView.back.frame.height + 2)
        chooseHoles.addTarget(self, action: #selector(holesClicked), for: .valueChanged)
        chooseHoles.selectedSegmentIndex = 0
        chooseHoles.selectedSegmentTintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        chooseHoles.backgroundColor = .white
        chooseHoles.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: UIFont.Weight(0.3))], for: .normal)
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        UISegmentedControl.appearance().setTitleTextAttributes(titleTextAttributes, for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes(titleTextAttributes, for: .normal)
        UISegmentedControl.appearance().setTitleTextAttributes(titleTextAttributes, for: .application)
        newGameView.addSubview(chooseHoles)
        
        func appendOption(_ option: String?, _ y: CGFloat) -> UIView{
            let optionView = UIView(frame: CGRect(x: 10, y: y+10, width: self.frame.width-20, height: 50))
            let label = UILabel(frame: CGRect(x: 20, y: 0, width: optionView.frame.width-40, height: optionView.frame.height))
            label.font = .systemFont(ofSize: 18, weight: UIFont.Weight(rawValue: 0.3))
            optionView.addSubview(label)
            label.text = option ?? "Play Without Course"
            self.addSubview(optionView)
            self.contentSize = CGSize(width: 0, height: optionView.frame.maxY)
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
        let without = appendOption(nil, self.contentSize.height+10)
        
        if (without.frame.maxY+10 < self.frame.height){
            self.frame = CGRect(x: 10, y: newGameView.back.frame.maxY+80, width: newGameView.frame.width-20, height: without.frame.maxY+10)
        }
    }
    
    @objc func locationClicked(sender: UIButton){
        if let location = sender.accessibilityLabel{
            newGameView.startGame(location)
        }
        else{
            newGameView.startGame(nil)
        }
    }
    
    // Changes the value of the hole selection, allowing the user to choose between 9 or 18 holes.
    
    @objc func holesClicked(sender: UISegmentedControl){
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        if (sender.selectedSegmentIndex == 0){
            newGameView.numberOfHoles = 9
        }
        else{
            newGameView.numberOfHoles = 18
        }
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
