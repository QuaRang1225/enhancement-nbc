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
    @Test func fetchRequest() async throws {
        await #expect(throws:DataError.requestFailed){
            try await NetworkAPIManager.fetchRates().value
        }
    }
    //MARK: 디코딩 에러
    @Test func decodigError() async throws {
        await #expect(throws:DataError.decodigError){
            try await NetworkAPIManager.fetchRates().value
        }
    }
    //MARK: 데이터 파싱 테스트
    @Test func fetchData() async throws{
        let data = try await NetworkAPIManager.fetchRates().value
        #expect(Exchange.getMock().rates == data)
    }
}
