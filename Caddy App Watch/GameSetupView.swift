//
//  NewGame.swift
//  Caddy App
//
//  Created by Karl Cridland on 30/04/2021.
//

import Foundation
import UIKit

class GameSetupView: ScreenView, UIScrollViewDelegate{
    
    let location: InputField
    let holeBackground = UIView()
    let save = UIButton()
    let info = UIButton()
    let playerLabel = UILabel()
    let holeScroll = UIScrollView()
    var nineHoles = true
    var parNumbers: NSMutableArray = [3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3]
    var numberOfHoles = 9
    
    var currentLocation: String?
    
    init(frame: CGRect, gameSetUp: HomeMenuView) {
        
        let width = CGFloat(Int.valueMax(Int(UIScreen.main.bounds.width-40), 350))
        var x = ((UIScreen.main.bounds.width - width)/2)
        location = InputField(frame: CGRect(x: x, y: 80, width: width, height: 100), title: "location", multiple: false)
        super .init(frame: frame)
        location.gameSetupView = self
        
        back.addTarget(self, action: #selector(backBackup), for: .touchUpInside)
        
        x = back.frame.maxX+20
        let title = UILabel(frame: CGRect(x: x, y: 20, width: self.frame.width-x-20, height: 40))
        title.text = "Game Setup"
        title.font = .systemFont(ofSize: 26, weight: UIFont.Weight(rawValue: 0.3))
        title.textAlignment = .right
        title.textColor = .black
        self.addSubview(title)
        
        self.addSubview(location)
        
        holeBackground.frame = CGRect(x: 20, y: location.frame.maxY+20, width: self.frame.width-40, height: UIScreen.main.bounds.height-(location.frame.maxY+220))
        holeBackground.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        holeBackground.layer.cornerRadius = location.layer.cornerRadius
        holeBackground.addShadow(0.3,5,5)
        self.addSubview(holeBackground)
        
        let titleLabel = UILabel(frame: CGRect(x: 20, y: 10, width: self.frame.width-40, height: 20))
        titleLabel.font = .systemFont(ofSize: 16, weight: UIFont.Weight(rawValue: 0.3))
        holeBackground.addSubview(titleLabel)
        titleLabel.textColor = .black
        titleLabel.text = "course details"
        
        let chooseHoles = UISegmentedControl(items: ["9 Holes", "18 Holes"])
        chooseHoles.frame = CGRect(x: 5, y: 40, width: holeBackground.frame.width-10, height: 50)
        chooseHoles.addTarget(self, action: #selector(holesClicked), for: .valueChanged)
        chooseHoles.selectedSegmentIndex = 0
        chooseHoles.overrideUserInterfaceStyle = .light
        chooseHoles.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
        chooseHoles.addShadow(0.3,1,3)
        holeBackground.addSubview(chooseHoles)

        holeScroll.frame = CGRect(x: 5, y: chooseHoles.frame.maxY+5, width: holeBackground.frame.width-10, height: holeBackground.frame.height-chooseHoles.frame.maxY-10)
        holeScroll.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1).withAlphaComponent(0.1)
        holeScroll.layer.cornerRadius = 8
        holeScroll.delegate = self
        holeBackground.addSubview(holeScroll)
        numberOfHoles = 9
        updateHoles()
        
        save.frame = CGRect(x: UIScreen.main.bounds.width/2 - 155, y: holeBackground.frame.maxY+30, width: 250, height: 50)
        save.backgroundColor = #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)
        save.titleLabel!.font = .systemFont(ofSize: 20, weight: UIFont.Weight(rawValue: 0.3))
        save.setTitle("save", for: .normal)
        self.addSubview(save)
        save.layer.cornerRadius = 8
        save.addShadow(0.6,1,3)
        save.addTarget(self, action: #selector(saveInfo), for: .touchUpInside)
        
        info.frame = CGRect(x: save.frame.maxX+10, y: save.frame.minY, width: 50, height: 50)
        info.backgroundColor = save.backgroundColor
        info.layer.cornerRadius = 8
        info.addShadow(0.6,1,3)
        info.setImage(UIImage(named: "info"), for: .normal)
        info.addTarget(self, action: #selector(showInfoOptions), for: .touchUpInside)
        self.addSubview(info)
        
        self.allowUserInteraction(false)
        self.location.reset {}
        
    }
    
    @objc func saveInfo(){
        Settings.shared.save()
        if (!Settings.saving){
            home.addSubview(SaveBanner())
            Settings.saving = true
        }
    }
    
    func allowUserInteraction(_ allow: Bool){
        [info,save,holeBackground].forEach { element in
            if (allow){
                element.alpha = 1
                element.isUserInteractionEnabled = true
            }
            else{
                element.alpha = 0.3
                element.isUserInteractionEnabled = false
            }
        }
    }
    
    @objc func showInfoOptions(){
        let cover = addCover()
        let titles = ["delete location","start game","view statistics","cancel"]
        let height = CGFloat(titles.count*60+10)
        let view = UIView(frame: CGRect(x: 10, y: UIScreen.main.bounds.height, width: cover.frame.width-20, height: height))
        cover.addSubview(view)
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { _ in
            UIView.animate(withDuration: 0.3) {
                cover.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1).withAlphaComponent(0.4)
                view.transform = CGAffineTransform(translationX: 0, y: -(height + Settings.bottom))
            }
        }
        
        view.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1)
        view.layer.cornerRadius = 10
        
        var buttons = [String:UIButton]()
        titles.enumerated().forEach({ (i,value) in
            let button = UIButton(frame: CGRect(x: 10, y: 10+(60*CGFloat(i)), width: view.frame.width-20, height: 50))
            buttons[value] = button
            button.titleLabel!.font = .systemFont(ofSize: 17, weight: UIFont.Weight(rawValue: 0.3))
            view.addSubview(button)
            button.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
            if (value == "delete location"){
                button.setTitleColor(#colorLiteral(red: 1, green: 0.4932718873, blue: 0.4739984274, alpha: 1), for: .normal)
            }
            button.setTitle(value, for: .normal)
            button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            button.addShadow(0.2,1,3)
            button.layer.cornerRadius = 8
            button.accessibilityElements = [view,cover]
            
        })
        
        cover.accessibilityElements = [view,cover]
        [buttons["cancel"]!,buttons["view statistics"]!,buttons["start game"]!,cover].forEach { button in
            button.addTarget(self, action: #selector(removeInfoOptions), for: .touchUpInside)
        }
        buttons["delete location"]!.addTarget(self, action: #selector(deleteLocation), for: .touchUpInside)
        buttons["start game"]!.addTarget(self, action: #selector(startGame), for: .touchUpInside)
    }
    
    @objc func startGame(){
        if let home = Settings.viewController?.homeView{
            home.location = currentLocation
            home.newGame()
        }
    }
    
    @objc func deleteLocation(sender: UIButton){
        
        let alert = UIAlertController(title: "Are you sure you want to delete this location?", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "cancel", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "delete", style: .destructive, handler: {_ in
            self.removeInfoOptions(sender: sender)
            self.location.hardResetDropdown()
            if let currentLocation = self.currentLocation{
                Settings.storage["location"]?.removeAll(where: {$0 == currentLocation})
            }
            Settings.shared.save()
            self.location.reset(){
                if (self.currentLocation == nil){
                    self.allowUserInteraction(false)
                }
            }
            if (!Settings.saving){
                home.addSubview(SaveBanner())
                Settings.saving = true
            }
        }))
        if let home = Settings.viewController{
            home.present(alert, animated: true)
        }
    }
    
    @objc func removeInfoOptions(sender: UIButton){
        if let view = sender.accessibilityElements?[0] as? UIView{
            if let cover = sender.accessibilityElements?[1] as? UIButton{
                UIView.animate(withDuration: 0.3) {
                    cover.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1).withAlphaComponent(0.0)
                    view.transform = CGAffineTransform.identity
                }completion: { _ in
                    cover.removeFromSuperview()
                }
            }
        }
    }
    
    @objc func showOption(){
        UIView.animate(withDuration: 0.3) {
            self.allowUserInteraction(true)
        }
    }
    
    @objc func backBackup(){
        if let dropdown = location.dropDown{
            UIView.animate(withDuration: 0.3) {
                dropdown.alpha = 0
            }
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        location.hardResetDropdown()
    }
    
    @objc func holesClicked(sender: UISegmentedControl){
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        nineHoles = sender.selectedSegmentIndex == 0
        if (nineHoles){
            numberOfHoles = 9
            updateHoles()
        }
        else{
            numberOfHoles = 18
            updateHoles()
        }
        location.hardResetDropdown()
    }
    
    func updateHoles(){
        let gap = CGFloat(8)
        holeScroll.subviews.forEach { subview in
            subview.removeFromSuperview()
        }
        parNumbers = [3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3]
        
        if let currentLocation = currentLocation{
            if let holes = Settings.holes[currentLocation]{
                holes.enumerated().forEach { (i,value) in
                    parNumbers[i] = value
                }
            }
        }
        for i in 0 ..< numberOfHoles{
            let view = UIView(frame: CGRect(x: gap, y: CGFloat(i)*(60+gap)+gap, width: holeScroll.frame.width-(gap*2), height: 60))
            holeScroll.contentSize = CGSize(width: holeScroll.frame.width, height: view.frame.maxY+gap)
            holeScroll.addSubview(view)
            view.backgroundColor = .white
            view.layer.cornerRadius = 6
            view.addShadow(0.3,1,3)
            
            let label = UILabel(frame: CGRect(x: 20, y: 0, width: 100, height: view.frame.height))
            label.font = .systemFont(ofSize: 18, weight: UIFont.Weight(rawValue: 0.3))
            label.text = "Hole \(i+1)"
            label.textColor = .black
            view.addSubview(label)
            
            let par = UILabel(frame: CGRect(x: view.frame.width-110, y: 35, width: 50, height: 20))
            par.text = "PAR"
            par.textColor = .black
            par.font = .systemFont(ofSize: 12, weight: UIFont.Weight(rawValue: 0.3))
            par.textAlignment = .center
            view.addSubview(par)
            
            let par_number = UILabel(frame: CGRect(x: view.frame.width-110, y: 5, width: 50, height: 30))
            par_number.font = .systemFont(ofSize: 24, weight: UIFont.Weight(rawValue: 0.3))
            par_number.textAlignment = .center
            par_number.textColor = .black
            view.addSubview(par_number)
            
            let plus = TargetButton(frame: CGRect(x: view.frame.width-55, y: 5, width: 50, height: 50))
            plus.tag = i
            plus.target = par_number
            plus.setImage(UIImage(named: "plus_blue"), for: .normal)
            plus.backgroundColor = .white
            plus.addShadow(0.3,1,3)
            plus.layer.cornerRadius = 5
            plus.addTarget(self, action: #selector(changePar), for: .touchUpInside)
            view.addSubview(plus)
            
            let minus = TargetButton(frame: CGRect(x: view.frame.width-165, y: 5, width: 50, height: 50))
            minus.tag = i
            minus.target = par_number
            minus.increase = false
            minus.setImage(UIImage(named: "minus_blue"), for: .normal)
            minus.backgroundColor = .white
            minus.addShadow(0.3,1,3)
            minus.layer.cornerRadius = 5
            minus.addTarget(self, action: #selector(changePar), for: .touchUpInside)
            view.addSubview(minus)
            
            minus.accessibilityElements = [minus,plus]
            plus.accessibilityElements = [minus,plus]
            
            if let n = parNumbers[i] as? Int{
                par_number.text = String(n)
                if (n == 3){
                    minus.alpha = 0.5
                    minus.setImage(UIImage(named: "minus"), for: .normal)
                }
                if (n == 6){
                    plus.alpha = 0.5
                    plus.setImage(UIImage(named: "plus"), for: .normal)
                }
            }
        }
    }
    
    @objc func changePar(sender: TargetButton){
        
        let minus = sender.accessibilityElements![0] as! UIButton
        let plus = sender.accessibilityElements![1] as! UIButton
        [minus,plus].forEach { button in
            button.alpha = 1
        }
        
        plus.setImage(UIImage(named: "plus_blue"), for: .normal)
        minus.setImage(UIImage(named: "minus_blue"), for: .normal)
        
        if (sender.increase){
            let new = (parNumbers[sender.tag] as! Int) + 1
            if (new <= 6){
                parNumbers[sender.tag] = new
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
            }
            if let n = parNumbers[sender.tag] as? Int, n == 6{
                plus.alpha = 0.5
                plus.setImage(UIImage(named: "plus"), for: .normal)
            }
        }
        else{
            let new = (parNumbers[sender.tag] as! Int) - 1
            if (new >= 3){
                parNumbers[sender.tag] = new
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
            }
            if let n = parNumbers[sender.tag] as? Int, n == 3{
                minus.alpha = 0.5
                minus.setImage(UIImage(named: "minus"), for: .normal)
            }
        }
        if let target = sender.target as? UILabel{
            if let value = parNumbers[sender.tag] as? Int{
                target.text = String(value)
            }
        }
        location.hardResetDropdown()
        
        if let currentLocation = currentLocation{
            Settings.holes[currentLocation] = parNumbers.array()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class TargetButton: UIButton {
    var target: Any?
    var increase = true
}

extension NSMutableArray{
    func array() -> [Int] {
        var temp = [Int]()
        self.enumerated().forEach { (i,value) in
            if let n = value as? Int{
                temp.append(n)
            }
        }
        return temp
    }
}
