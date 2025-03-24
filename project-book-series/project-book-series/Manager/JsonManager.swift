//
//  JsonManager.swift
//  project-book-series
//
//  Created by 유영웅 on 3/24/25.
//

import Foundation


//MARK: Json파일 디코딩 매니저
//앱 실행 시 한번만 초기화 하여 프로퍼티에 저장하여 사용할 예정
//그럼으로 상태성을 가질 필요가 없기 때문에 타입 메서드로 구현
final class JsonManager{
    static func loadJson() async throws -> Result<[Attributes],DataError>{
        guard let path = Bundle.main.path(forResource: "data", ofType: "json") else { throw DataError.fileNotFound}
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            let bookResponse = try JSONDecoder().decode(Episode.self, from: data)
            return .success(bookResponse.data.map{ $0.attributes })
        } catch {
            print("🚨 JSON 파싱 에러 : \(error)")
            throw DataError.parsingFailed
        }
    }
}
