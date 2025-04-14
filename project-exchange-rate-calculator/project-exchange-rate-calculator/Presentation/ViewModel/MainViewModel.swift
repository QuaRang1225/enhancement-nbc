//
//  MainViewModel.swift
//  project-exchange-rate-calculator
//
//  Created by 유영웅 on 4/14/25.
//

import Foundation
import RxSwift

//MARK: MainViewModel - MainView의 비즈니스 로직 및 바인딩 관리
class MainViewModel: ViewModelProtocol {
    
    private let actionSubject = PublishSubject<Action>()
    
    var state = State()
    var disposeBag = DisposeBag()
    
    // 이벤트를 Observer타입으로 변경
    var action: AnyObserver<Action> {
        actionSubject.asObserver()
    }
    
    // 주입 받을 이벤트 타입
    enum Action{
        case fetchInfo
    }
    
    // View에 전달될 상태 데이터
    struct State{
        fileprivate(set) var responseData = BehaviorSubject<ExchangeRatesResponse>(value: [:])
    }
    
    // 액션에 따라 구독할 이벤트 분기처리
    init() {
        actionSubject
            .withUnretained(self)
            .subscribe(onNext: { owner, action in
                switch action {
                case .fetchInfo:
                    owner.fetchExchangeRates()
                }
            })
            .disposed(by: disposeBag)
    }
    // 네트워크 API fetch
    private func fetchExchangeRates() {
        NetworkAPIManager.fetchRates()
            .subscribe(with: self, onSuccess: { owner, response in
                owner.state.responseData.onNext(response)
            }, onFailure: { owner, error in
                if let error = error as? DataError {
                    print("\(error)")
                }
            })
            .disposed(by: disposeBag)
    }
}
