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
        let length = frame.height-40
        let gap = (((frame.width-length)/2)-length)/2
        self.decrease = UIButton(frame: CGRect(x: gap, y: 20, width: length, height: length))
        self.increase = UIButton(frame: CGRect(x: (2*gap)+(length), y: 20, width: length, height: length))
        self.nextHole = UIButton(frame: CGRect(x: (3*gap)+(2*length), y: 20, width: length, height: length))
        super .init(frame: frame)
        let images = ["minus.square.fill","plus.square.fill","arrow.right"]
        [self.decrease,self.increase,self.nextHole].enumerated().forEach { (i,button) in
            button.setUpGameButton(images[i])
            self.addSubview(button)
        }
        let topBar = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 2))
        topBar.backgroundColor = #colorLiteral(red: 0, green: 0.9810667634, blue: 0.5736914277, alpha: 1)
        self.addSubview(topBar)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension UIButton{
    
    func setUpGameButton(_ image: String) {
        self.backgroundColor = #colorLiteral(red: 0, green: 0.9810667634, blue: 0.5736914277, alpha: 1)
        self.setImage(UIImage(named: image), for: .normal)
        self.layer.cornerRadius = 8
    }
}
