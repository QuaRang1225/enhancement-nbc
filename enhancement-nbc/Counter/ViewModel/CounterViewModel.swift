//
//  CounterViewModel.swift
//  enhancement-nbc
//
//  Created by 유영웅 on 2/19/25.
//

import Foundation

class CounterViewModel{
    var counter = Counter(num: 0)
    
    var completion:((Int)->Void)?
    
    func increase(){
        guard counter.num < 10 else {return}
        counter.num += 1
        completion?(counter.num)
    }
    func decrease(){
        guard counter.num > -10 else {return}
        counter.num -= 1
        completion?(counter.num)
    }
    func reset(){
        counter.num = 0
        completion?(counter.num)
    }
}
