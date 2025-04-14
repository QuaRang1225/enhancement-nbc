//
//  ViewController.swift
//  project-exchange-rate-calculator
//
//  Created by 유영웅 on 4/14/25.
//

import UIKit
import RxSwift

class MainViewController: UIViewController {
    
    let vm = MainViewModel()
    var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        bindViewModel()
        vm.action.onNext(.fetchInfo)
    }
    
    // ViewModel간의 데이터 바인딩
    func bindViewModel(){
        // API 데이터 fetch
        vm.state.responseData
            .subscribe { response in
                print(response)
            }
            .disposed(by: disposeBag)
    }
}

