//
//  ExchangeRateCell.swift
//  project-exchange-rate-calculator
//
//  Created by 유영웅 on 4/14/25.
//

import Foundation
import UIKit
import Then
import SnapKit

final class ExchangeRateCell: UITableViewCell {
    
    // ID
    static let idenfier = "ExchangeRateCell"
    
    // 국가 코드 라벨
    private let countryCodeLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 18, weight: .bold)
    }
    
    // 환율 라벨
    private let rateLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 18)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureSubView()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // cell 컴포넌트 데이터 업데이트
    public func configure(response: ExchangeRatesResponse){
        countryCodeLabel.text = response.key
        rateLabel.text = String(format: "%.4f", response.value)
    }
    
    // sub view 추가
    private func configureSubView(){
        [countryCodeLabel, rateLabel]
            .forEach{ addSubview($0) }
    }
    
    // 오토 레이아웃
    private func configureLayout(){
        countryCodeLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(8)
        }
        rateLabel.snp.makeConstraints {
            $0.centerY.equalTo(countryCodeLabel)
            $0.trailing.equalToSuperview().offset(-8)
        }
    }
}
