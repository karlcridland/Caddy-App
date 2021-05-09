//
//  CurrentHole.swift
//  Caddy App Watch
//
//  Created by Karl Cridland on 07/05/2021.
//

import Foundation
import UIKit

class CurrentHole: UIView {
    
    private let hole: UILabel
    private let score: UILabel
    
    override init(frame: CGRect) {
        self.hole = UILabel(frame: CGRect(x: 20, y: 0, width: frame.width/2-20, height: frame.height))
        self.score = UILabel(frame: CGRect(x: frame.width/2, y: 0, width: frame.width/2-20, height: frame.height))
        super .init(frame: frame)
        [self.hole,self.score].forEach { button in
            self.addSubview(button)
            button.title()
        }
        self.score.textAlignment = .right
        
        let bottomBar = UIView(frame: CGRect(x: 0, y: self.frame.height-2, width: self.frame.width, height: 2))
        bottomBar.backgroundColor = .white
        self.addSubview(bottomBar)
    }
    
    // Method updates the hole, if a hole has been previously updated then the score is set to that otherwise
    // it starts from zero.
    
    func updateHole(_ hole: Int, _ score: Int?) {
        self.hole.text = "Hole \(hole)"
        if let score = score{
            updateScore(score)
        }
        else{
            updateScore(0)
        }
    }
    
    func updateScore(_ score: Int) {
        self.score.text = "score: \(score)"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension UILabel{
    func title() {
        self.textColor = .white
        self.font = .systemFont(ofSize: 26, weight: UIFont.Weight(rawValue: 0.3))
    }
}
