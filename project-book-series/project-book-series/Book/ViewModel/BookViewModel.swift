//
//  AttributesViewModel.swift
//  project-Attributes-series
//
//  Created by 유영웅 on 4/1/25.
//

import Foundation
import RxSwift
import RxCocoa

//protocol AttributesViewModelType {
//    associatedtype Input
//    associatedtype Output
//    
//    func transform(input: Input) -> Output
//}

final class BookViewModel {
    
//    //MARK: Input&Output 패턴
//    struct Input {
//        let buttonTap: Observable<Void>
//    }
//    struct Output {
//        let expand: Driver<Bool>
//    }
//    func transform(input: Input) -> Output {
//        input.buttonTap
//            .withLatestFrom(expandRelay)
//            .map{ !$0 }
//            .bind(to: expandRelay)
//            .disposed(by: disposeBag)
//        let expand = expandRelay
//            .asDriver(onErrorJustReturn: false)
//        return Output(expand: expand)
//    }
//    
//    let expandRelay = BehaviorRelay<Bool>(value: false)
    
    //MARK: 프로퍼티 선언
    //disposeBag
    private let disposeBag = DisposeBag()
    //속성 배열
    public var attributes = [Attributes]()
    // 데이터 변경을 감지하는 Subject
    var attributesSubject = PublishSubject<[Attributes]>()
    // 데이터 로드를 트리거하는 Subject
    var fetchObservable = Observable<Void>.just(())
    
    init() {
        cofigureBindings()
    }
    // MARK: - 바인딩 설정
    private func cofigureBindings() {
        fetchObservable
            .subscribe(onNext: { [weak self] _ in
                self?.fetchAttributes()
            })
            .disposed(by: disposeBag)
    }
    // MARK: - JSON 데이터 로드
    private func fetchAttributes() {
        Task {
            do {
                print("ㄷ")
                let attributes = try await JsonManager.loadJson().get()
                print("ㄹ")
                self.attributes = attributes
                attributesSubject.onNext(attributes)
                attributesSubject.onCompleted()
            } catch let error {
                attributesSubject.onError(error)
            }
        }
    }
}
