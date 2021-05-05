//
//  InputField.swift
//  Caddy App
//
//  Created by Karl Cridland on 30/04/2021.
//

import Foundation
import UIKit

class InputField: UIView {
    
    var options: [String]
    let title: String
    let dropdownButton = UIButton()
    var location: String?
    var dropDown: UIScrollView?
    var buttons = [UIButton]()
    var gameSetupView: GameSetupView?
    var form: AppendOption?
    
    init(frame: CGRect, title: String, multiple: Bool) {
        if let options = Settings.storage[title]{
            self.options = options
        }
        else{
            self.options = []
        }
        self.title = title
        super .init(frame: frame)
        self.backgroundColor = .white
        self.layer.cornerRadius = 8
        self.addShadow(0.2,5,5)
        
        let titleLabel = UILabel(frame: CGRect(x: 20, y: 10, width: self.frame.width-40, height: 20))
        titleLabel.font = .systemFont(ofSize: 16, weight: UIFont.Weight(rawValue: 0.3))
        titleLabel.textColor = .black
        self.addSubview(titleLabel)
        titleLabel.text = title
        
        dropdownButton.frame = CGRect(x: 10, y: 40, width: self.frame.width-80, height: 50)
        dropdownButton.contentEdgeInsets = UIEdgeInsets(top: 0.0, left:20.0, bottom: 0.0, right: 20.0)
        dropdownButton.titleLabel!.font = .systemFont(ofSize: 16, weight: UIFont.Weight(rawValue: 0.3))
        dropdownButton.contentHorizontalAlignment = .left
        dropdownButton.backgroundColor = .white
        dropdownButton.addShadow(0.3,1,3)
        dropdownButton.layer.cornerRadius = 5
        self.addSubview(dropdownButton)
        
        let newOption = UIButton(frame: CGRect(x: dropdownButton.frame.maxX+10, y: 40, width: 50, height: 50))
        newOption.backgroundColor = .white
        newOption.addShadow(0.3,1,3)
        newOption.layer.cornerRadius = 5
        newOption.setImage(UIImage(named: "plus"), for: .normal)
        self.addSubview(newOption)
        
        dropdownButton.addTarget(self, action: #selector(chooseOption), for: .touchUpInside)
        newOption.addTarget(self, action: #selector(appendOptions), for: .touchUpInside)
        
        reset(){}
    }
    
    func reset(callback: @escaping ()->Void){
        if let update = Settings.storage[title]{
            self.options = update
        }
        dropdownButton.setTitleColor(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1), for: .normal)
        switch options.count {
        case 0:
            dropdownButton.setTitle("create a \(title)", for: .normal)
            userInteraction(allow: false)
        case 1:
            dropdownButton.setTitleColor(#colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1), for: .normal)
            updateLocation(options[0])
            userInteraction(allow: true)
        default:
            dropdownButton.setTitle("choose a \(title)", for: .normal)
            userInteraction(allow: true)
        }
        if let gameSetupView = gameSetupView{
            gameSetupView.updateHoles()
        }
        callback()
    }
    
    func updateLocation(_ location: String){
        self.location = location
        self.dropdownButton.setTitle(location, for: .normal)
        self.dropdownButton.setTitleColor(#colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1), for: .normal)
        if let gameSetupView = gameSetupView{
            gameSetupView.currentLocation = location
            gameSetupView.updateHoles()
        }
    }
    
    @objc func hardResetDropdown(){
        if let dropdown = dropDown{
            let button = UIButton()
            button.accessibilityElements = [dropdown]
            resetDropdown(sender: button)
        }
    }
    
    @objc func appendOptions(){
        hardResetDropdown()
        let cover = addCover()
        cover.addTarget(self, action: #selector(removeFromSuper), for: .touchUpInside)
        
        let width = CGFloat(Int.valueMax(Int(self.frame.width-40), 400))
        let x = ((cover.frame.width - width)/2)
        
        
        form = AppendOption(frame: CGRect(x: x, y: 100, width: width, height: 170), title: self.title, cover: cover, field: self)
        cover.accessibilityElements = [form!]
        form!.alpha = 0
        cover.addSubview(form!)
        form!.append.addTarget(self, action: #selector(allowUserInteraction), for: .touchUpInside)
        
        Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { _ in
            UIView.animate(withDuration: 0.3) {
                cover.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1).withAlphaComponent(0.3)
                self.form!.alpha = 1
                self.form!.transform = CGAffineTransform(translationX: 0, y: 50)
            }
        }

    }
    
    @objc func allowUserInteraction(){
        if let gameSetupView = gameSetupView{
            if let form = self.form, form.ready{
                gameSetupView.allowUserInteraction(true)
            }
        }
    }
    
    func userInteraction(allow: Bool){
        if let gameSetupView = gameSetupView{
            gameSetupView.allowUserInteraction(allow)
        }
    }
    
    @objc func chooseOption(sender: UIButton){
        if let update = Settings.storage[title]{
            self.options = update
        }
        if (options.count > 1){
            sender.alpha = 0
            
//            let cover = addCover()
//            cover.addTarget(self, action: #selector(resetDropdown), for: .touchUpInside)
//            home.addSubview(cover)
            
            let frame = sender.convert(sender.frame, to: home)
            let dropdown = UIScrollView(frame: CGRect(x: frame.minX - sender.frame.minX, y: frame.minY - sender.frame.minY, width: sender.frame.width, height: sender.frame.height))
            dropDown = dropdown
//            cover.accessibilityElements = [dropdown,cover]
            dropdown.addShadow(0.3,1,3)
            dropdown.layer.cornerRadius = 5
            dropdown.backgroundColor = .white
            dropdown.layer.borderWidth = 2
            dropdown.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            home.addSubview(dropdown)
            
            var i = 0
            var picked: UIButton?
            options.forEach { option in
                let button = UIButton(frame: CGRect(x: 0, y: CGFloat(i) * dropdownButton.frame.height, width: dropdown.frame.width, height: dropdownButton.frame.height))
                buttons.append(button)
                button.setTitle(option, for: .normal)
                button.setTitleColor(.black, for: .normal)
                button.contentEdgeInsets = UIEdgeInsets(top: 0.0, left:20.0, bottom: 0.0, right: 20.0)
                button.titleLabel!.font = .systemFont(ofSize: 16, weight: UIFont.Weight(rawValue: 0.3))
                button.contentHorizontalAlignment = .left
                button.backgroundColor = .white
                button.accessibilityElements = [dropdown]
                
                if (location == option){
                    dropdown.contentOffset = CGPoint(x: 0, y: button.frame.minY)
                    picked = button
                }
                
                button.addTarget(self, action: #selector(optionClicked), for: .touchUpInside)
                if let gameSetupView = gameSetupView{
                    button.addTarget(gameSetupView, action: #selector(gameSetupView.showOption), for: .touchUpInside)
                }
                
                dropdown.addSubview(button)
                i += 1
            }
            dropdown.contentSize = CGSize(width: 0, height: CGFloat(i) * dropdownButton.frame.height)
            
            buttons.forEach { button in
                button.accessibilityElements = [dropdown,buttons]
            }
            
            let height = Int.valueMax(options.count*Int(sender.frame.height), 300)
            UIView.animate(withDuration: 0.3) {
                dropdown.frame = CGRect(x: dropdown.frame.minX, y: dropdown.frame.minY, width: dropdown.frame.width, height: CGFloat(height))
                dropdown.layer.borderColor = #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)
                dropdown.contentOffset = CGPoint(x: 0, y: 0)
                
                if let button = picked{
                    button.setTitleColor(#colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1), for: .normal)
                }
            }
        }
    }
    
    @objc func cancelOptionClick(sender: UIButton){
        resetDropdown(sender: sender)
    }
    
    @objc func optionClicked(sender: UIButton){
        updateLocation(sender.titleLabel!.text!)
        resetDropdown(sender: sender)
        
        if let gameSetupView = gameSetupView{
            gameSetupView.currentLocation = sender.titleLabel!.text
            gameSetupView.updateHoles()
        }
        
        if let buttons = sender.accessibilityElements?[1] as? [UIButton]{
            buttons.forEach { button in
                button.setTitleColor(.black, for: .normal)
            }
        }
        sender.setTitleColor(#colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1), for: .normal)
        
    }
    
    @objc func resetDropdown(sender: UIButton){
        if let dropdown = sender.accessibilityElements?[0] as? UIScrollView{
            UIView.animate(withDuration: 0.3) {
                dropdown.contentOffset = CGPoint(x: 0, y: sender.frame.minY)
                dropdown.frame = CGRect(x: dropdown.frame.minX, y: dropdown.frame.minY, width: dropdown.frame.width, height: self.dropdownButton.frame.height)
                dropdown.addShadow(0.3,1,3)
                dropdown.layer.borderColor = #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1).withAlphaComponent(0).cgColor
            } completion: { _ in
                dropdown.removeFromSuperview()
                self.dropdownButton.alpha = 1
            }
        }
    }
    
    @objc func removeFromSuper(sender: UIButton){
        if let elements = sender.accessibilityElements as? [UIView]{
            UIView.animate(withDuration: 0.3) {
                sender.alpha = 0
                elements.forEach { element in
                    element.transform = CGAffineTransform(translationX: 0, y: -50)
                }
            }completion: { _ in
                sender.removeFromSuperview()
            }
        }
        else{
            sender.removeFromSuperview()
        }
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
