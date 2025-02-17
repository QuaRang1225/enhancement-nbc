//
//  Counter.swift
//  enhancement-nbc
//
//  Created by 유영웅 on 2/17/25.
//

import Foundation

struct Counter{
    var num = 0
    
    mutating func increase(){
        guard num < 10 else {return}
        num += 1
    }
    mutating func decrease(){
        guard num > -10 else {return}
        num -= 1
    }
    mutating func reset(){
        num = 0
    }
}
