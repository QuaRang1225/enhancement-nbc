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
import RxSwift
import RxCocoa

//MARK: 환율데이터 셀
final class ExchangeRateCell: UITableViewCell {
    
    // ID
    static let idenfier = "ExchangeRateCell"
    
    // dispseBag
    private var disposeBag = DisposeBag()
    
    //delegate
    weak var delegate:ExchangeRateCellDelegate?
    
    private var exchangeRate: ExchangeRateModel?
    
    private var isBookmarked = BehaviorRelay<Bool>(value: false)
    
    // 국가 코드 라벨
    private lazy var currencyLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .medium)
    }
    
    // 환율 라벨
    private lazy var rateLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16)
        $0.textAlignment = .right
    }
    
    // 국가 라벨
    private lazy var countryLabel = UILabel().then {
        $0.textColor = .gray
        $0.font = .systemFont(ofSize: 14)
    }
    
    // 즐겨찾기 라벨
    public lazy var bookmarkButton = UIButton().then {
        $0.isExclusiveTouch = true
        $0.tintColor = .systemYellow
    }
    
    // 셀 컨텐츠 뷰
    private lazy var labelStackView = UIStackView(arrangedSubviews: [currencyLabel, countryLabel]).then {
        $0.axis = .vertical
        $0.spacing = 4
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        configureSubView()
        configureLayout()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    // cell 컴포넌트 데이터 업데이트
    public func configure(response: ExchangeRateModel){
        self.exchangeRate = response
        
        let image = UIImage(systemName: response.isBookmark ? "star.fill" : "star")
        bookmarkButton.setImage(image, for: .normal)
        countryLabel.text = exchangeRate?.country
        rateLabel.text = String(format: "%.4f", response.rate)
        currencyLabel.text = response.currency
        isBookmarked.accept(response.isBookmark)
        bind()
    }
    
    // sub view 추가
    private func configureSubView(){
        [rateLabel, labelStackView, bookmarkButton]
            .forEach { contentView.addSubview($0) }
    }
    
    // 오토 레이아웃
    private func configureLayout(){
        
        // 라벨 스택 뷰
        labelStackView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
        }
        
        // 환율 라벨
        rateLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.greaterThanOrEqualTo(labelStackView.snp.trailing).offset(16)
            $0.width.equalTo(120)
        }
        
        //즐겨 찾기 버튼
        bookmarkButton.snp.makeConstraints {
            $0.leading.equalTo(rateLabel.snp.trailing).offset(16)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-16)
        }
    }
    
    private func bind() {
        bookmarkButton.rx.tap
            .observe(on: MainScheduler.instance)
            .withLatestFrom(isBookmarked)
            .bind(with: self){ owner, bookmark in
                guard var model = owner.exchangeRate else { return }
                model.isBookmark = !bookmark
                owner.delegate?.touchBookmark(model: model)
            }
            .disposed(by: disposeBag)
    }
}
