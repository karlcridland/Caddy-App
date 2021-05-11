//
//  GameOver.swift
//  Caddy App Watch
//
//  Created by Karl Cridland on 11/05/2021.
//

import Foundation
import UIKit

class GameOver: UIView {
    init(frame: CGRect, course: String?, scores: [Int: Int], newGameView: NewGameView) {
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
