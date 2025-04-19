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
        case fecthExchageRate(id: UUID)
        case calculate(input: Double)
    }
    
    // View에 전달될 상태 데이터
    struct State{
        fileprivate(set) var actionSubject = PublishSubject<Action>()
        
        fileprivate(set) var exchageRate = BehaviorSubject<ExchangeRateModel?>(value: nil)
        fileprivate(set) var calculatedRate = PublishSubject<String>()
    }
    
    // 액션에 따라 구독할 이벤트 분기처리
    init(){
        state.actionSubject
            .subscribe(with: self) { owner, type in
                switch type{
                case let .fecthExchageRate(id):
                    owner.fetchPersistenceEntity(id: id)
                case let .calculate(input):
                    owner.calculateRate(input: input)
                }
            }
            .disposed(by: disposeBag)
    }
    
    // Persistence 저장소에서 환율정보 fetch
    private func fetchPersistenceEntity(id: UUID) {
        PersistenceManager.shared.fetch(id: id)
            .subscribe(with: self) { owner, response in
                guard let response else { return print("데이터를 찾을 수 없습니다.") }
                owner.state.exchageRate.onNext(response)
            }
            .disposed(by: disposeBag)
    }
    
    
    // 계산 결과 텍스트 생성
    private func calculateRate(input: Double) {
        guard let item = try? state.exchageRate.value() else { return }
        
        let inputString = String(format: "$%.2f", input)
        let resultString = String(format: "%.2f", input * item.rate)
        let result = inputString + " → " + resultString + " " + item.currency
        state.calculatedRate.onNext(result)
    }
}
