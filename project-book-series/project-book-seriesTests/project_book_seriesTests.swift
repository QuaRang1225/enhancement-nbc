//
//  project_book_seriesTests.swift
//  project-book-seriesTests
//
//  Created by 유영웅 on 3/24/25.
//

import Testing
@testable import project_book_series

struct project_book_seriesTests {

    //MARK: 파일을 찾을 수 없을 때
    @Test func fileNotFound() async throws {
        await #expect(throws:DataError.fileNotFound){
            try await JsonManager.loadJson()
        }
    }
    //MARK: 파싱이 불가능할 때()
    @Test func parsingFailed() async throws {
        await #expect(throws:DataError.parsingFailed){
            try await JsonManager.loadJson()
        }
    }
}
