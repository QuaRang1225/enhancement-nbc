//
//  Extension+Date.swift
//  project-exchange-rate-calculator
//
//  Created by 유영웅 on 4/19/25.
//

import Foundation

extension Date {
    
    // Date to String
    func dateToString() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "E, dd MMM yyyy HH:mm:ss z"
        return formatter.string(from: self)
    }
}
