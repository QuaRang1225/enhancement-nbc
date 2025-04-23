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
        
        fileprivate(set) var searchText = ""
        fileprivate(set) var lastExchangeRates = [ExchangeRateModel]()
    }
    
    private let apiUseCase: FetchAPIExchangeRateUseCase
    private let localUseCase: ExchangeRatePersistentUseCase
    private let lastScreenUseCase: LastScreenPersistentUseCase
    
    // 액션에 따라 구독할 이벤트 분기처리
    init(
        apiUseCase: FetchAPIExchangeRateUseCase,
        localUseCase: ExchangeRatePersistentUseCase,
        lastScreenUseCase: LastScreenPersistentUseCase
    ) {
        self.apiUseCase = apiUseCase
        self.localUseCase = localUseCase
        self.lastScreenUseCase = lastScreenUseCase
        
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
        localUseCase.fetchAll()
            .subscribe(with: self, onSuccess: { owner, list in
                let changedDate = UserDefaultManager.shared.changedDate(key: .date, newDate: Date())
                if list.isEmpty || changedDate{
                    owner.fetchExchangeRates(list: list)
                } else {
                    owner.state.lastExchangeRates = list
                    owner.state.filteredExchangeRates.onNext(list)
                }
            }, onFailure: { owner, error in
                owner.state.filteredExchangeRates.onError(error)
            })
            .disposed(by: disposeBag)
    }
    
    // 네트워크 API fetch시 실행
    private func fetchExchangeRates(list: [ExchangeRateModel]) {
        apiUseCase.fetchRates()
            .subscribe(with: self, onSuccess: { owner, entitys in
                Task{
                    owner.calculateRateOfChage(list, entitys)       // list - 기존에 저장된 데이터, entitys - 새로 불러온 데이터
                    UserDefaultManager.shared.setDate(key: .date, newDate: Date())
                }
            }, onFailure: { owner, error in
                owner.state.filteredExchangeRates.onError(error)
            })
            .disposed(by: disposeBag)
    }
    
    // 최근 환율과의 차이 계산
    private func calculateRateOfChage(_ oldRates: [ExchangeRateModel], _ newRates: [ExchangeRateModel]) {
        Task {
            do {
                guard !oldRates.isEmpty else {
                    try await localUseCase.saveAll(models: newRates)
                    state.lastExchangeRates = newRates
                    state.filteredExchangeRates.onNext(newRates)
                    return
                }

                let oldRateDict = Dictionary(uniqueKeysWithValues: oldRates.map { ($0.id, $0) })
                let updatedRates = newRates.map { new in
                    var item = new
                    if let old = oldRateDict[new.id] {
                        item.rateOfChange = new.rate - old.rate
                    }
                    return item
                }

                try await localUseCase.updateAll(models: updatedRates)
                state.lastExchangeRates = updatedRates
                state.filteredExchangeRates.onNext(updatedRates)
            } catch {
                state.filteredExchangeRates.onError(error)
            }
        }
    }
    
    // 검색 텍스트 변경 시 실행
    private func filteringExchangeRates(text: String){
        guard let list = try? state.filteredExchangeRates.value() else { return }
        
        state.searchText = text
        let responseList = text.isEmpty ?
        state.lastExchangeRates : list.filter {
            return $0.currency.contains(text.uppercased()) || $0.country.contains(text)
        }
        state.filteredExchangeRates.onNext(responseList)
    }
    
    // 즐겨 찾기 실행
    private func bookmark(model: ExchangeRateModel) {
        Task {
            try await localUseCase.update(model: model)
            self.fetchPersistenceEntitys()
            self.filteringExchangeRates(text: state.searchText)
        }
    }
    
    // 앱 종료 후 시작 시점에 view를 불러오기 위한 item 저장
    private func saveLast(id: UUID? = nil) {
        Task {
            if let id {
                try await lastScreenUseCase.save(type: .calculator, currencyID: id)
            } else {
                try await lastScreenUseCase.save(type: .list, currencyID: nil)
            }
        }
    }
}
