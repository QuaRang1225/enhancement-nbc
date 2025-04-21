//
//  LastScreenRepository.swift
//  project-exchange-rate-calculator
//
//  Created by 유영웅 on 4/21/25.
//

import Foundation

// MARK: 스크린 타입
enum LastScreenType: String {
    case list
    case calculator
}

// MARK: 스크린 케이스 Repository
protocol LastScreenRepository {
    func saveLastScreen(type: LastScreenType, currencyID: UUID?) async throws
    func fetchLastScreen() -> (LastScreenType, UUID?)?
}
