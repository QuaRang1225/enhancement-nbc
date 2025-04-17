//
//  CalculatorViewModel.swift
//  project-exchange-rate-calculator
//
//  Created by 유영웅 on 4/16/25.
//

import Foundation
import RxSwift

// MARK: MainViewModel - CalculatorView의 비즈니스 로직 및 바인딩 관리
final class CalculatorViewModel: ViewModelProtocol {
    
    var state = State()
    var disposeBag = DisposeBag()
    
    // 이벤트를 Observer타입으로 변경
    var action: AnyObserver<Action> {
        state.actionSubject.asObserver()
    }
    
    // 주입 받을 이벤트 타입
    enum Action{
        case calculate(input: Double, item: ExchangeRatesResponse)
    }
    
    // View에 전달될 상태 데이터
    struct State{
        fileprivate(set) var actionSubject = PublishSubject<Action>()
        
        fileprivate(set) var calculatedRate = PublishSubject<String>()
    }
    
    // 액션에 따라 구독할 이벤트 분기처리
    init(){
        state.actionSubject
            .subscribe(with: self){ owner, type in
                switch type{
                case let .calculate(input, item):
                    owner.calculateRate(input: input, item: item)
                }
            }
            .disposed(by: disposeBag)
    }
    
    // 계산 결과 텍스트 생성
    private func calculateRate(input: Double, item: ExchangeRatesResponse) {
        let inputString = String(format: "$%.2f", input)
        let resultString = String(format: "%.2f", input * item.value)
        let result = inputString + " → " + resultString + " " + item.key
        state.calculatedRate.onNext(result)
    }
}
