//
//  LastScreenPersistentUseCase.swift
//  project-exchange-rate-calculator
//
//  Created by 유영웅 on 4/22/25.
//

import Foundation

// MARK: - 스크린 타입 유즈케이스 Protocol
protocol LastScreenPersistentUseCase {
    func save(type: LastScreenType, currencyID: UUID?) async throws
    func fetch() -> (LastScreenType, UUID?)?
}
