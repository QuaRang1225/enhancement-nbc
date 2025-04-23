//
//  ExchangeRatePersistentUseCase.swift
//  project-exchange-rate-calculator
//
//  Created by 유영웅 on 4/22/25.
//

import Foundation
import RxSwift

// MARK: - CoreData 환율 데이터 유즈케이스 Protocol
protocol ExchangeRatePersistentUseCase {
    func saveAll(models: [ExchangeRateModel]) async throws
    func fetchAll() -> Single<[ExchangeRateModel]>
    func fetch(id: UUID) -> Single<ExchangeRateModel?>
    func update(model: ExchangeRateModel) async throws
    func updateAll(models: [ExchangeRateModel]) async throws
}
