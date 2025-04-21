//
//  DefaultSaveLastScreenUseCase.swift
//  project-exchange-rate-calculator
//
//  Created by 유영웅 on 4/22/25.
//

import Foundation

// MARK: - 스크린 타입 요청 유즈케이스
final class DefaultLastScreenPersistentUseCase: LastScreenPersistentUseCase {
    
    private let repository: LastScreenPersistentRepository
    
    init(repository: LastScreenPersistentRepository) {
        self.repository = repository
    }
    
    func save(type: LastScreenType, currencyID: UUID?) async throws {
        try await repository.saveLastScreen(type: type, currencyID: currencyID)
    }
    
    func fetch() -> (LastScreenType, UUID?)? {
        return repository.fetchLastScreen()
    }
}
