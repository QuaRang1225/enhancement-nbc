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
        case searchText(text: String)
        case bookmark(model: ExchangeRateModel)
        case cellTouch(id: UUID?)
    }
    
    // View에 전달될 상태 데이터
    struct State{
        fileprivate(set) var actionSubject = PublishSubject<Action>()
        fileprivate(set) var filteredExchangeRates = BehaviorSubject<[ExchangeRateModel]>(value: [])
        fileprivate(set) var selectedItem = PublishSubject<ExchangeRateModel>()
        
        fileprivate(set) var lastExchangeRates = [ExchangeRateModel]()
    }
    
    // 액션에 따라 구독할 이벤트 분기처리
    init() {
        state.actionSubject
            .withUnretained(self)
            .subscribe(onNext: { owner, action in
                switch action {
                case .fetchInfo:
                    owner.fetchPersistenceEntitys()
                case let .searchText(text):
                    owner.filteringExchangeRates(text: text)
                case let .bookmark(model):
                    owner.bookmark(model: model)
                case let .cellTouch(id):
                    owner.saveLast(id: id)
                }
            })
            .disposed(by: disposeBag)
    }
    
    // CoreData DB 데이터 조회
    private func fetchPersistenceEntitys(){
        PersistenceManager.shared.fetchAll()
            .subscribe(with: self, onSuccess: { owner, list in
                let changedDate = UserDefaultManager.shared.changedDate(key: .date, newDate: Date())
                if list.isEmpty {
                    owner.fetchExchangeRates()
                } else if changedDate {
                    owner.fetchExchangeRates(list: list)
                }else{
                    owner.state.lastExchangeRates = list
                    owner.state.filteredExchangeRates.onNext(list)
                }
            }, onFailure: { owner, error in
                owner.state.filteredExchangeRates.onError(error)
            })
            .disposed(by: disposeBag)
    }
    
    // 네트워크 API fetch시 실행
    private func fetchExchangeRates(list: [ExchangeRateModel] = []) {
        NetworkAPIManager.fetchRates()
            .subscribe(with: self, onSuccess: { owner, entitys in
                Task{
                    do {
                        if !list.isEmpty {
                            let newModel = zip(entitys, list).map { new, old in
                                var item = new
                                item.rateOfChange = new.rate - old.rate
                                return item
                            }
                            try await PersistenceManager.shared.saveAll(entitys: newModel)
                            owner.state.lastExchangeRates = newModel
                            owner.state.filteredExchangeRates.onNext(newModel)
                        } else {
                            try await PersistenceManager.shared.saveAll(entitys: entitys)
                            owner.state.lastExchangeRates = entitys
                            owner.state.filteredExchangeRates.onNext(entitys)
                        }
                        UserDefaultManager.shared.setDate(key: .date, newDate: Date())
                    } catch {
                        owner.state.filteredExchangeRates.onError(error)
                    }
                }
            }, onFailure: { owner, error in
                owner.state.filteredExchangeRates.onError(error)
            })
            .disposed(by: disposeBag)
    }
    
    // 검색 텍스트 변경 시 실행
    private func filteringExchangeRates(text: String){
        let responseList = text.isEmpty ?
        state.lastExchangeRates : state.lastExchangeRates.filter {
            return $0.currency.contains(text.uppercased()) || $0.country.contains(text)
        }
        state.filteredExchangeRates.onNext(responseList)
    }
    
    // 즐겨 찾기 실행
    private func bookmark(model: ExchangeRateModel) {
        Task {
            try await PersistenceManager.shared.update(model: model)
            self.fetchPersistenceEntitys()
        }
    }
    
    // 앱 종료 후 시작 시점에 view를 불러오기 위한 item 저장
    private func saveLast(id: UUID? = nil) {
        Task {
            if let id {
                try await PersistenceManager.shared.saveLastScreen(type: .calculator, currencyID: id)
            } else {
                try await PersistenceManager.shared.saveLastScreen(type: .list)
            }
        }
    }
}
