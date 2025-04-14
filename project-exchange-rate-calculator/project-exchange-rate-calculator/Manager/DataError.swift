//
//  DataError.swift
//  project-exchange-rate-calculator
//
//  Created by 유영웅 on 4/14/25.
//

import Foundation

//MARK: DataError - 에러 핸들링을 위함
enum DataError: String, Error{
    case requestFailed = "요청 실패"
    case decodigError = "디코딩 에러"
}
