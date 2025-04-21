//
//  ExchangeRateRepository.swift
//  project-exchange-rate-calculator
//
//  Created by 유영웅 on 4/21/25.
//

import Foundation
import RxSwift

// MARK: 네트워크 API 환율 데이터 Repository
protocol ExchangeRateAPIRepository {
    func fetchRates() -> Single<[ExchangeRateModel]>
}
