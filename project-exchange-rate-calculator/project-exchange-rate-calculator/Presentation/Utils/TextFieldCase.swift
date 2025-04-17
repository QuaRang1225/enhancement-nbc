//
//  TextFieldCase.swift
//  project-exchange-rate-calculator
//
//  Created by 유영웅 on 4/16/25.
//

import Foundation

// MARK: 환율 계산 텍스트 필드값에 따른 에러 케이스
enum TextFieldCase: String {
    case isEmpty = "금액을 입력해주세요"
    case isNotDouble = "올바른 숫자를 입력해주세요"
}
