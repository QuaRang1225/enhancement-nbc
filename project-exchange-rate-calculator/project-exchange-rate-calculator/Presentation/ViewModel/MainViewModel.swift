//
//  MainViewModel.swift
//  project-exchange-rate-calculator
//
//  Created by 유영웅 on 4/14/25.
//

import Foundation
import RxSwift

// MARK: MainViewModel - MainView의 비즈니스 로직 및 바인딩 관리
final class MainViewModel: ViewModelProtocol {
    
    var state = State()
    var disposeBag = DisposeBag()
    
    // 이벤트를 Observer타입으로 변경
    var action: AnyObserver<Action> {
        state.actionSubject.asObserver()
    }
    
    // 주입 받을 이벤트 타입
    enum Action{
        case fetchInfo
        case searchText(String)
    }
    
    // View에 전달될 상태 데이터
    struct State{
        fileprivate(set) var actionSubject = PublishSubject<Action>()
        fileprivate(set) var filteredExchangeRates = BehaviorSubject<[ExchangeRate]>(value: [])
        
        fileprivate(set) var exchangeRates = [ExchangeRate]()
    }
    
    // 액션에 따라 구독할 이벤트 분기처리
    init() {
        state.actionSubject
            .withUnretained(self)
            .subscribe(onNext: { owner, action in
                switch action {
                case .fetchInfo:
                    owner.fetchPersistenceExchangeRates()
                case .searchText(let text):
                    owner.filteringExchangeRates(text: text)
                }
            })
            .disposed(by: disposeBag)
    }
    
    // CoreData DB 데이터 조회
    private func fetchPersistenceExchangeRates(){
        PersistenceManager.shared.fetchAll(type: ExchangeRate.self)
            .subscribe(with: self) { owner, list in
                if list.isEmpty{
                    owner.fetchExchangeRates()
                }else{
                    owner.state.exchangeRates = list
                    owner.state.filteredExchangeRates.onNext(list)
                }
            }
            .disposed(by: self.disposeBag)
    }
    
    // 네트워크 API fetch시 실행
    private func fetchExchangeRates() {
        NetworkAPIManager.fetchRates()
            .subscribe(with: self, onSuccess: { owner, response in
                Task{
                    let entitys = try await PersistenceManager.shared.saveAll(type: ExchangeRate.self, values: response)
                    owner.state.exchangeRates = entitys
                    owner.state.filteredExchangeRates.onNext(entitys)
                }
            }, onFailure: { owner, error in
                owner.state.filteredExchangeRates.onError(error)
            })
            .disposed(by: disposeBag)
    }
    
    
    // 검색 텍스트 변경 시 실행
    private func filteringExchangeRates(text: String){
        
        let responseList = text.isEmpty ?
        state.exchangeRates :
        state.exchangeRates.filter {
            guard let currency = $0.currency, let country = $0.country else { return false }
            return currency.contains(text.uppercased()) || country.contains(text)
        }
        state.filteredExchangeRates.onNext(responseList)
    }
}
