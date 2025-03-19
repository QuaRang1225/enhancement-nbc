//
//  LV2.swift
//  project-advance
//
//  Created by 유영웅 on 3/19/25.
//

import Foundation

let numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

var result = numbers.filter{ $0%2 == 0 }.map{ "\($0)" }
