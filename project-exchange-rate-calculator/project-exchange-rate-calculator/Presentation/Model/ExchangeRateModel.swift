//
//  ExchangeRateModel.swift
//  project-exchange-rate-calculator
//
//  Created by 유영웅 on 4/19/25.
//

import Foundation

struct ExchangeRateModel: Codable {
    let id: UUID
    let currency: String
    let country: String
    var rate: Double
    var isBookmark: Bool
    var rateOfChange: Double
}
