//
//  MockAPIRepository.swift
//  project-exchange-rate-calculatorTests
//
//  Created by 유영웅 on 4/22/25.
//

import Foundation
import RxSwift
@testable import project_exchange_rate_calculator

final class MockRemoteRepository: ExchangeRateAPIRepository {
    var shouldThrow = false
    func fetchRates() -> Single<[ExchangeRateModel]> {
        if shouldThrow {
            return .error(DataError.requestFailed)
        }
        return .just(Exchange.getMock().toModel())
    }
}
