//
//  Int.swift
//  Caddy App
//
//  Created by Karl Cridland on 30/04/2021.
//

import Foundation


extension Int{
    
    static func valueMax(_ number: Int, _ max: Int) -> Int{
        if (number > max){
            return max
        }
        return number
    }
    
}
