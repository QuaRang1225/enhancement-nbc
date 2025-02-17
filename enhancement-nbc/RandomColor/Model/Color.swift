//
//  Color.swift
//  enhancement-nbc
//
//  Created by 유영웅 on 2/17/25.
//

import Foundation
import UIKit

struct Color {
   var randomColor: UIColor = .white
   var text: String = "R: 255, G: 255, B: 255"
   
   mutating func getRandomColor() {
       let r = CGFloat.random(in: 0...1)
       let g = CGFloat.random(in: 0...1)
       let b = CGFloat.random(in: 0...1)
       self.randomColor = UIColor(red: r, green: g, blue: b, alpha: 1.0)
       self.text = "R: \(Int(r * 255)), G: \(Int(g * 255)), B: \(Int(b * 255))"
   }
   
    mutating func resetColor() {
       self.randomColor = .white
       self.text = "R: 255, G: 255, B: 255"
   }
}
