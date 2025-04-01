//
//  SummaryAttributes.swift
//  project-book-series
//
//  Created by 유영웅 on 4/1/25.
//


import Foundation

struct SummaryAttributes:Codable{
    var text:String = ""
    var cut:String = ""
    lazy var cutCount = cut.count
}