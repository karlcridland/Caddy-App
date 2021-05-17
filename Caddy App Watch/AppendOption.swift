//
//  AppendOption.swift
//  Caddy App
//
//  Created by Karl Cridland on 30/04/2021.
//

import Foundation
import UIKit

class AppendOption: UIView{
    
    let title: String
    let append = UIButton()
    let input = TextField()
    let cover: UIButton?
    let field: InputField
    var ready = false
    
    init(frame: CGRect, title: String, cover: UIButton?, field: InputField) {
        
        self.title = title
        self.cover = cover
        self.field = field
        
        super .init(frame: frame)
        self.backgroundColor = .white
        self.layer.cornerRadius = 8
        self.addShadow(0.2,5,5)
        
        let titleLabel = UILabel(frame: CGRect(x: 20, y: 0, width: frame.width-40, height: 50))
        titleLabel.font = .systemFont(ofSize: 16, weight: UIFont.Weight(rawValue: 0.3))
        titleLabel.text = "new \(title)"
        titleLabel.textAlignment = .left
        titleLabel.textColor = .black
        self.addSubview(titleLabel)
        
        input.frame = CGRect(x: 20, y: 50, width: frame.width-40, height: 50)
        input.addTarget(self, action: #selector(textEdited), for: .allEditingEvents)
        input.addShadow(0.3,1,3)
        input.backgroundColor = .white
        input.textColor = .black
        input.layer.cornerRadius = 5
        self.addSubview(input)
        
        append.frame = CGRect(x: frame.width/2+15, y: 115, width: frame.width/2-35, height: 40)
        append.titleLabel!.font = .systemFont(ofSize: 16, weight: UIFont.Weight(rawValue: 0.3))
        append.setTitle("save", for: .normal)
        append.setTitleColor(#colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1), for: .normal)
        append.layer.borderColor = #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)
        append.layer.borderWidth = 2
        append.layer.cornerRadius = 5
        append.addTarget(self, action: #selector(appendOption), for: .touchUpInside)
        self.addSubview(append)
        
        let cancel = UIButton()
        cancel.frame = CGRect(x: 20, y: 115, width: frame.width/2-35, height: 40)
        cancel.titleLabel!.font = .systemFont(ofSize: 16, weight: UIFont.Weight(rawValue: 0.3))
        cancel.setTitle("cancel", for: .normal)
        cancel.setTitleColor(#colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1), for: .normal)
        cancel.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        cancel.layer.borderWidth = 2
        cancel.addTarget(self, action: #selector(removeFromSuper), for: .touchUpInside)
        self.addSubview(cancel)
        
        input.becomeFirstResponder()
    }
    
    @objc func removeFromSuper() {
        if let cover = cover{
            field.removeFromSuper(sender: cover)
        }
        else{
            self.removeFromSuperview()
        }
    }
    
    @objc func appendOption(){
        if (self.ready){
            if (!Settings.storage.keys.contains(title)){
                Settings.storage[title] = []
            }
            Settings.storage[title]?.append(input.text!)
            field.updateLocation(input.text!)
            field.gameSetupView?.updateHoles()
            removeFromSuper()
        }
    }
    
    @objc func textEdited(sender: UITextField){
        UIView.animate(withDuration: 0.4) {
            
            var titles = [String]()
            if let storage = Settings.storage[self.title]{
                titles = storage
            }
            
            if (sender.text!.count > 0 && !titles.contains(sender.text!)){
                self.append.layer.borderColor = #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)
                self.append.setTitleColor(#colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1), for: .normal)
                self.ready = true
            }
            else{
                self.append.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1).withAlphaComponent(0.4).cgColor
                self.append.setTitleColor (#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1).withAlphaComponent(0.4), for: .normal)
                self.ready = false
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

