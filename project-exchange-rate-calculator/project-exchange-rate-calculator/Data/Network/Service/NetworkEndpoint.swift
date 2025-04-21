//
//  NetworkEndpoint.swift
//  project-exchange-rate-calculator
//
//  Created by 유영웅 on 4/21/25.
//

import Foundation

// MARK: Endpoint 설정
enum NetworkEndpoint: String {
    
    case usd = "USD"
    
    static let baseURL = "https://open.er-api.com/v6"

    static func url(_ url: Self) -> URL? {
        return URL(string: "\(baseURL)/latest/\(url)")!
    }
}
