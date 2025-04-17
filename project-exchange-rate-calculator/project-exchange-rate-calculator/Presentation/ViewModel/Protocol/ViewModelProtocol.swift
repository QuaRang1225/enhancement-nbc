//
//  ViewModelProtocol.swift
//  project-exchange-rate-calculator
//
//  Created by 유영웅 on 4/14/25.
//

import Foundation
import RxSwift

// MARK: ViewModel이 꼭 준수해야하는 프로토콜
protocol ViewModelProtocol{
    associatedtype Action
    associatedtype State
    
    var disposeBag: DisposeBag { get }          // DisposeBag
    var action: AnyObserver<Action> { get }     // Action을 주입받을 통로
    var state: State { get }                    // View 쪽에 전달되는 상태 스트림
}
