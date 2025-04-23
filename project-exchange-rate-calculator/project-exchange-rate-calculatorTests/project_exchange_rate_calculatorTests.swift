//
//  project_exchange_rate_calculatorTests.swift
//  project-exchange-rate-calculatorTests
//
//  Created by 유영웅 on 4/14/25.
//

import Testing
@testable import project_exchange_rate_calculator

struct project_exchange_rate_calculatorTests {
    
    //MARK: url이 존재하지 않을 때
    @Test func requestFailed() async throws {
        let mock = MockRemoteRepository()
        mock.shouldThrow = true
        let useCase = DefaultFetchAPIExchangeRateUseCase(repository: mock)
        
        await #expect(throws: DataError.requestFailed) {
            try await useCase.fetchRates().value
        }
    }
    
    //MARK: 디코딩 에러
    @Test func decodigError() async throws {
        let mock = MockRemoteRepository()
        mock.shouldThrow = true
        let useCase = DefaultFetchAPIExchangeRateUseCase(repository: mock)
        
        #expect(throws: DataError.decodigError) {
            useCase.fetchRates()
        }
    }
    
    //MARK: 데이터 파싱 테스트
    @Test func fetchRequest() async throws {
        let mock = MockRemoteRepository()
        mock.shouldThrow = false
        let useCase = DefaultFetchAPIExchangeRateUseCase(repository: mock)
        
        let data = try await useCase.fetchRates().value
        #expect(data == Exchange.getMock().toModel())
    }
}
