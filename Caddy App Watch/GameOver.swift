//
//  GameOver.swift
//  Caddy App Watch
//
//  Created by Karl Cridland on 11/05/2021.
//

import Foundation
import UIKit

class GameOver: UIView {
    
    let newGame: GOButton
    let mainMenu: GOButton
    let statistics: GOButton
    
    init(frame: CGRect, course: String?, scores: [Int: Int], newGameView: NewGameView) {
        self.newGame = GOButton(frame: CGRect(x: 30, y: 200, width: frame.width-60, height: 50), title: "play again")
        self.mainMenu = GOButton(frame: CGRect(x: 30, y: 270, width: frame.width-60, height: 50), title: "main menu")
        self.statistics = GOButton(frame: CGRect(x: 30, y: 340, width: frame.width-60, height: 50), title: "statistics")
        super .init(frame: frame)
        
        let header = UILabel(frame: CGRect(x: 20, y: 50, width: self.frame.width-40, height: 50))
        header.text = course ?? "Game Over."
        header.format(22)
        self.addSubview(header)
        
        var score = 0
        scores.forEach { n in
            score += n.value
        }
        let scored = UILabel(frame: CGRect(x: 20, y: header.frame.maxY, width: self.frame.width-40, height: 50))
        scored.text = "Score: \(score)"
        scored.format(20)
        self.addSubview(scored)
        
        [self.newGame,self.mainMenu,self.statistics].forEach { button in
            self.addSubview(button)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension UILabel{
    func format(_ size: CGFloat) {
        self.font = .systemFont(ofSize: size, weight: UIFont.Weight(0.3))
        self.textColor = .white
        self.textAlignment = .center
    }
}

class GOButton: UIButton {
    
    let title: String
    let maxWidth = 300
    
    init(frame: CGRect, title: String) {
        self.title = title
        super .init(frame: frame)
        self.setTitle(title, for: .normal)
        self.setTitleColor(.black, for: .normal)
        self.titleLabel?.format(18)
        
        self.layer.cornerRadius = 4
        self.backgroundColor = #colorLiteral(red: 0, green: 0.9810667634, blue: 0.5736914277, alpha: 1)
        
        if (self.frame.width > CGFloat(maxWidth)){
            let center = self.center
            self.frame = CGRect(x: 0, y: 0, width: CGFloat(maxWidth), height: self.frame.height)
            self.center = center
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
