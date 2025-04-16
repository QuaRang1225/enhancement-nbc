//
//  CalculatorViewModel.swift
//  project-exchange-rate-calculator
//
//  Created by 유영웅 on 4/16/25.
//

import Foundation
import RxSwift

final class CalculatorViewModel: ViewModelProtocol {
    
    var state = State()
    var disposeBag = DisposeBag()
    
    // 이벤트를 Observer타입으로 변경
    var action: AnyObserver<Action> {
        state.actionSubject.asObserver()
    }
    
    // 주입 받을 이벤트 타입
    enum Action{
        case calculate(Double)
    }
    
    // View에 전달될 상태 데이터
    struct State{
        fileprivate(set) var actionSubject = PublishSubject<Action>()
        
        fileprivate(set) var calculatedRate = PublishSubject<String>()
    }
    
    init(){
        state.actionSubject
            .subscribe(with: self){ owner, type in
                switch type{
                case .calculate(let value):
                    owner.calculateRate(value: value)
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func calculateRate(value: Double) {
        state.calculatedRate.onNext(String(value))
    }
}
