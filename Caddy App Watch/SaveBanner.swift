//
//  SaveBanner.swift
//  Caddy App Watch
//
//  Created by Karl Cridland on 02/05/2021.
//

import Foundation
import UIKit

class SaveBanner: UIView {
    init(){
        super .init(frame: CGRect(x: 10, y: Settings.top, width: UIScreen.main.bounds.width-20, height: 100))
        self.backgroundColor = .white
        self.addShadow(0.4, 10, 10)
        self.layer.cornerRadius = 8
        
        let activity = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        self.addSubview(activity)
        activity.color = .black
        activity.style = .large
        activity.startAnimating()
        
        let text = UILabel(frame: CGRect(x: 100, y: 0, width: self.frame.width-120, height: 100))
        text.font = .systemFont(ofSize: 20, weight: UIFont.Weight(rawValue: 0.3))
        text.textColor = .black
        text.text = "Saving.."
        self.addSubview(text)
        
        self.transform = CGAffineTransform(translationX: 0, y: -(self.frame.minY+self.frame.height))
        UIView.animate(withDuration: 0.6) {
            self.transform = CGAffineTransform.identity
        }completion: { _ in
            Timer.scheduledTimer(withTimeInterval: 1.2, repeats: false) { _ in
                text.text = "Saved."
                activity.stopAnimating()
                
                let jobDone = UILabel(frame: activity.frame)
                self.addSubview(jobDone)
                jobDone.text = "✅"
                jobDone.font = .systemFont(ofSize: 20)
                jobDone.textAlignment = .center
                jobDone.transform = CGAffineTransform(scaleX: 1.6, y: 1.6)
                
                Timer.scheduledTimer(withTimeInterval: 0.8, repeats: false) { _ in
                    UIView.animate(withDuration: 0.6) {
                        self.transform = CGAffineTransform(translationX: 0, y: -(self.frame.minY+self.frame.height))
                    }completion: { _ in
                        Settings.saving = false
                    }
                }
            }
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
