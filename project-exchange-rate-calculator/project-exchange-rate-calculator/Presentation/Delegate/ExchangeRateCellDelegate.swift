//
//  ExchangeRateCellDelegate.swift
//  project-exchange-rate-calculator
//
//  Created by 유영웅 on 4/17/25.
//

import Foundation

protocol ExchangeRateCellDelegate: AnyObject {
    func touchBookmark(id: UUID)
}
