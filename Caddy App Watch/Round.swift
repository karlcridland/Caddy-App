//
//  Round.swift
//  Caddy App
//
//  Created by Karl Cridland on 30/04/2021.
//

import Foundation

class Round{
    
    static var players = [Player]()
    
    let holes: [Hole]
    init (hole_pars: [Int]){
        var temp = [Hole]()
        for h in hole_pars{
            let hole = Hole(par: h)
            temp.append(hole)
        }
        self.holes = temp
    }
}

