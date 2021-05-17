//
//  DropdownView.swift
//  Caddy App Watch
//
//  Created by Karl Cridland on 17/05/2021.
//

import Foundation
import UIKit

class DropdownView: UIView{
    
    private var choices: [String]?
    let dropdown: UIScrollView
    let button: UIButton
    
    init(frame: CGRect, choices: [String]?, placeholder: String) {
        self.choices = choices
        self.dropdown = UIScrollView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        self.button = UIButton(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        super .init(frame: frame)
        
        self.addSubview(self.button)
        self.addSubview(self.dropdown)
        self.button.addTarget(self, action: #selector(displayDropdown), for: .touchUpInside)
        self.updateChoices(nil)
        
        self.button.setTitle(placeholder, for: .normal)
        self.button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        self.button.titleLabel?.font = .systemFont(ofSize: 18, weight: UIFont.Weight(rawValue: 0.3))
        self.button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.button.setTitleColor(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1), for: .normal)
        self.button.contentHorizontalAlignment = .left
        self.button.addShadow(0.3,1,3)
        self.button.layer.cornerRadius = 5
        
        self.dropdown.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.dropdown.addShadow(0.3,1,3)
        self.dropdown.layer.cornerRadius = 5
        self.dropdown.isHidden = true
        
    }
    
    @objc func displayDropdown(){
        self.dropdown.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        self.dropdown.isHidden = false
        if let choices = choices{
            UIView.animate(withDuration: 0.3) {
                self.dropdown.alpha = 1
                self.dropdown.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: CGFloat([190, choices.count*40].min()!))
                self.frame = CGRect(x: self.frame.minX, y: self.frame.minY, width: self.frame.width, height: self.dropdown.frame.height)
            }completion: { _ in
                self.dropdown.isHidden = false
            }
        }
    }
    
    @objc func updateChoice(sender: UIButton) {
        self.button.setTitle(sender.titleLabel!.text, for: .normal)
        self.button.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        self.dropdown.isHidden = false
        UIView.animate(withDuration: 0.3) {
            self.dropdown.alpha = 0
            self.dropdown.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
            self.frame = CGRect(x: self.frame.minX, y: self.frame.minY, width: self.frame.width, height: 40)
        }completion: { _ in
            self.dropdown.isHidden = true
            self.dropdown.subviews.forEach { subview in
                if let button = subview as? UIButton{
                    button.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
                }
                sender.setTitleColor(#colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1), for: .normal)
            }
        }
    }
    
    func updateChoices(_ newChoices: [String]?){
        
        if let newChoices = newChoices{
            self.choices = newChoices
        }
        
        if let choices = choices{
            choices.enumerated().forEach { (i, choice) in
                let button = UIButton(frame: CGRect(x: 0, y: CGFloat(i)*40, width: self.frame.width, height: 40))
                button.tag = i
                button.addTarget(self, action: #selector(updateChoice), for: .touchUpInside)
                self.dropdown.addSubview(button)
                
                button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
                button.setTitle(choice, for: .normal)
                button.titleLabel?.font = .systemFont(ofSize: 18, weight: UIFont.Weight(rawValue: 0.3))
                button.contentHorizontalAlignment = .left
                button.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
                
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
