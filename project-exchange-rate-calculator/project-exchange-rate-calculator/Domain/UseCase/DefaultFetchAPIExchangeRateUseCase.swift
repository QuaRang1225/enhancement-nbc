//
//  DefaultFetchRemoteExchageRateUseCase.swift
//  project-exchange-rate-calculator
//
//  Created by 유영웅 on 4/22/25.
//

import Foundation
import RxSwift

// MARK: - 네트워크 API 데이터 요청 유즈케이스
final class DefaultFetchAPIExchangeRateUseCase: FetchAPIExchangeRateUseCase {

    private let repository: ExchangeRateAPIRepository

    init(repository: ExchangeRateAPIRepository) {
        self.repository = repository
    }

    func fetchRates() -> Single<[ExchangeRateModel]> {
        return repository.fetchRates()
    }
}
