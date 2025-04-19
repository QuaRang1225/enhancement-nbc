//
//  ExchangeRateCellDelegate.swift
//  project-exchange-rate-calculator
//
//  Created by 유영웅 on 4/17/25.
//

import Foundation

// MARK: Cell 데이터 ViewController로 이전
protocol ExchangeRateCellDelegate: AnyObject {
    func touchBookmark(model: ExchangeRateModel)
}
