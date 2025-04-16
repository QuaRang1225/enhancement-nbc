//
//  CalculatorView.swift
//  project-exchange-rate-calculator
//
//  Created by 유영웅 on 4/15/25.
//

import Foundation
import UIKit
import SnapKit
import Then

final class CalculatorView: UIView {
    
    // 타이틀 라벨
    private let titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 36, weight: .bold)
        $0.text = "환율 계산기"
    }
    
    // 국가 코드 라벨
    private let currencyLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 24, weight: .bold)
    }
    
    // 국가 라벨
    private let countryLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .bold)
    }
    
    // 결과 값 라벨
    private let resultLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 20, weight: .medium)
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    
    // 텍스트 필드
    private let amountTextField = UITextField().then {
        $0.borderStyle = .roundedRect
        $0.keyboardType = .decimalPad
        $0.textAlignment = .center
        $0.placeholder = "금액을 입력하세요"
    }
    
    // 계산 버튼
    private let convertButton = UIButton().then {
        $0.backgroundColor = .systemBlue
        $0.tintColor = .white
        $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
    }
    
    // 라벨 스택 (국가 코드 + 쿡가)
    private lazy var labelStackView = UIStackView(arrangedSubviews: [currencyLabel, countryLabel]).then {
        $0.axis = .vertical
        $0.spacing = 0
    }
}
