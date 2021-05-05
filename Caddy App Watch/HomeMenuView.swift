//
//  GameSetUp.swift
//  Caddy App
//
//  Created by Karl Cridland on 30/04/2021.
//

import Foundation
import UIKit

class HomeMenuView: UIView{
    
    var location: String?
    
    init(){
        super .init(frame: CGRect(x: 0, y: Settings.top, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height-(Settings.bottom)))
        self.homescreen()
        self.layer.cornerRadius = Settings.cornerRadius
    }
    
    @objc func homescreen() {
        self.changeBackground(#colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1))
        self.removeItems(.fade) {
            let width = CGFloat(Int.valueMax(Int(self.frame.width-40), 300))
            let x = ((self.frame.width - width)/2)
            var i = CGFloat(0)
            var buttons = [String: UIButton]()
            ["new game","game setup","statistics"].forEach { title in
                let button = UIButton(frame: CGRect(x: x, y: 160+(i*70), width: width, height: 50))
                buttons[title] = button
                button.backgroundColor = .white
                button.setTitle(title, for: .normal)
                button.setTitleColor(.black, for: .normal)
                button.layer.cornerRadius = 8
                button.addShadow(0.2,5,5)
                
                if let titleLabel = button.titleLabel{
                    titleLabel.font = .systemFont(ofSize: 18, weight: UIFont.Weight(rawValue: 0.3))
                }
                
                self.addSubview(button)
                i += 1
            }
            
            buttons["new game"]?.addTarget(self, action: #selector(self.newGame), for: .touchUpInside)
            buttons["game setup"]?.addTarget(self, action: #selector(self.setupGame), for: .touchUpInside)
        }
    }
    
    func changeBackground(_ color: UIColor) {
        UIView.animate(withDuration: 0.3) {
            self.backgroundColor = color
        }
    }
    
    func removeItems(_ style: removeStyle, _ callback: @escaping ()->Void) {
        UIView.animate(withDuration: 0.5) {
            self.subviews.forEach { subview in
                switch style{
                case .fly:
                    subview.transform = CGAffineTransform(translationX: 0, y: -UIScreen.main.bounds.height)
                    subview.alpha = 0
                    break
                default:
                    subview.alpha = 0
                }
            }
        } completion: { _ in
            self.subviews.forEach { subview in
                subview.removeFromSuperview()
            }
            callback()
        }
    }
    
    @objc func newGame(){
        self.changeBackground(#colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1))
        removeItems(.fly) {
            let newGame = NewGameView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height), location: self.location)
            self.addSubview(newGame)
        }
    }
    
    @objc func setupGame(){
        self.changeBackground(#colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1))
        self.removeItems(.fly) {
            let gameSetupView = GameSetupView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height), gameSetUp: self)
            self.addSubview(gameSetupView)
            gameSetupView.back.addTarget(gameSetupView.location, action: #selector(gameSetupView.location.hardResetDropdown), for: .touchUpInside)
        }
    }
    
    enum removeStyle{
        case fade
        case fly
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
