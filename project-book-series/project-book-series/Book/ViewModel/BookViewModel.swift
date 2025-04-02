//
//  BookViewModel.swift
//  project-book-series
//
//  Created by 유영웅 on 4/1/25.
//

import Foundation
import RxSwift
import RxCocoa

final class BookViewModel {
    
    private let disposeBag = DisposeBag()
    // 데이터 변경을 감지하는 Subject
    var attributesSubject = PublishSubject<[Attributes]>()
    // 데이터 로드를 트리거하는 Subject
    var fetchSubject = PublishSubject<Void>()
    
    init() {
        cofigureBindings()
    }
    
    // MARK: - 바인딩 설정
    private func cofigureBindings() {
        fetchSubject
            .subscribe(onNext: { [weak self] _ in
                self?.fetchAttributes()
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - JSON 데이터 로드
    private func fetchAttributes() {
        Task {
            do {
                let attributes = try await JsonManager.loadJson().get()
                attributesSubject.onNext(attributes)
            } catch let error {
                attributesSubject.onError(error)
            }
        }
    }
}
