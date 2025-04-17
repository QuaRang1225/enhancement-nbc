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

// MARK: 환율 계산기 화면
final class CalculatorView: UIView {
    
    //아이템 정보
    public var item:ExchangeRatesResponse? = nil
    
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
        $0.font = .systemFont(ofSize: 16)
        $0.textColor = .gray
    }
    
    // 결과 값 라벨
    public let resultLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 20, weight: .medium)
        $0.textAlignment = .center
        $0.numberOfLines = 0
        $0.text = "계산 결과가 여기에 표시됩니다."
    }
    
    // 텍스트 필드
    public let amountTextField = UITextField().then {
        $0.borderStyle = .roundedRect
        $0.keyboardType = .decimalPad
        $0.textAlignment = .center
        $0.placeholder = "금액을 입력하세요"
    }
    
    // 계산 버튼
    public let convertButton = UIButton().then {
        $0.setTitle("환율 계산", for: .normal)
        $0.backgroundColor = .systemBlue
        $0.tintColor = .white
        $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        $0.layer.cornerRadius = 8
    }
    
    // 라벨 스택 (국가 코드 + 쿡가)
    private lazy var labelStackView = UIStackView(arrangedSubviews: [currencyLabel, countryLabel]).then {
        $0.axis = .vertical
        $0.alignment = .center
        $0.spacing = 0
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureSubView()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 데이터 설정
    public func configure(item:ExchangeRatesResponse) {
        self.item = item
        currencyLabel.text = item.key
        countryLabel.text = String.iso_code[item.key]
    }
    
    // 컴포넌트 추가
    private func configureSubView() {
        [titleLabel, labelStackView, amountTextField, convertButton, resultLabel]
            .forEach{ addSubview($0)}
    }
    private func configureLayout() {
        
        // 타이틀 라벨
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).inset(4)
            $0.leading.equalTo(safeAreaLayoutGuide).inset(24)
        }
        
        // 라벨 스택
        labelStackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(32)
            $0.centerX.equalToSuperview()
        }
        
        // 텍스트 필드
        amountTextField.snp.makeConstraints {
            $0.top.equalTo(labelStackView.snp.bottom).offset(32)
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.height.equalTo(44)
        }
        
        // 계산 버튼
        convertButton.snp.makeConstraints {
            $0.top.equalTo(amountTextField.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.height.equalTo(44)
        }
        
        // 결과 라벨
        resultLabel.snp.makeConstraints {
            $0.top.equalTo(convertButton.snp.bottom).offset(32)
            $0.horizontalEdges.equalToSuperview().inset(24)
        }
    }
}


