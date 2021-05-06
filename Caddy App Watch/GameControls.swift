//
//  GameControls.swift
//  Caddy App Watch
//
//  Created by Karl Cridland on 06/05/2021.
//

import Foundation
import UIKit

class GameControls: UIView {
    
    let decrease: UIButton
    let increase: UIButton
    let nextHole: UIButton
    
    override init(frame: CGRect){
        let width = (frame.width-80)/3
        let top = (frame.height-width)/2
        self.decrease = UIButton(frame: CGRect(x: 20, y: top, width: width, height: width))
        self.increase = UIButton(frame: CGRect(x: 40+width, y: top, width: width, height: width))
        self.nextHole = UIButton(frame: CGRect(x: 60+(2*width), y: top, width: width, height: width))
        super .init(frame: frame)
        let images = ["minus.square.fill","plus.square.fill","arrow.right.circle.fill"]
        [self.decrease,self.increase,self.nextHole].enumerated().forEach { (i,button) in
            button.setUpGameButton(images[i])
            self.addSubview(button)
        }
        self.backgroundColor = #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension UIButton{
    
    func setUpGameButton(_ image: String) {
        self.tintColor = #colorLiteral(red: 0, green: 0.9810667634, blue: 0.5736914277, alpha: 1)
    }
}
