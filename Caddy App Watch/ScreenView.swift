//
//  ScreenView.swift
//  Caddy App Watch
//
//  Created by Karl Cridland on 02/05/2021.
//

import Foundation
import UIKit

class ScreenView: UIView {
    
    let back = UIButton()
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        
        back.frame = CGRect(x: 20, y: 20, width: 80, height: 40)
        back.titleLabel!.font = .systemFont(ofSize: 16, weight: UIFont.Weight(rawValue: 0.3))
        back.setTitle("back", for: .normal)
        back.setTitleColor(#colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1), for: .normal)
        back.backgroundColor = .white
        back.addShadow(0.3,1,3)
        back.layer.cornerRadius = 5
        self.addSubview(back)
        if let home = Settings.viewController?.homeView{
            self.back.addTarget(home, action: #selector(home.homescreen), for: .touchUpInside)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

