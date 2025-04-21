//
//  DefaultExchangeRatePersistentUseCase.swift
//  project-exchange-rate-calculator
//
//  Created by 유영웅 on 4/22/25.
//

import Foundation
import RxSwift

// MARK: - CoreData 환율 데이터 유즈케이스
final class DefaultExchangeRatePersistentUseCase: ExchangeRatePersistentUseCase {
    private let repository: ExchangeRatePersistentRepository

    init(repository: ExchangeRatePersistentRepository) {
        self.repository = repository
    }

    func saveAll(models: [ExchangeRateModel]) async throws {
        try await repository.saveAll(models: models)
    }

    func fetchAll() -> Single<[ExchangeRateModel]> {
        return repository.fetchAll()
    }

    func fetch(id: UUID) -> Single<ExchangeRateModel?> {
        return repository.fetch(id: id)
    }

    func update(model: ExchangeRateModel) async throws {
        try await repository.update(model: model)
    }
}
