//
//  ViewController.swift
//  project-exchange-rate-calculator
//
//  Created by 유영웅 on 4/14/25.
//

import UIKit
import RxSwift
import RxCocoa

class MainViewController: UIViewController {
    
    private let vm = MainViewModel()
    private let mainView = MainView()
    var disposeBag = DisposeBag()
    
    // VC 뷰 설정
    override func loadView() {
        self.view = mainView
    }
    
    // 초기 VC 설정
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        bindViewModel()
        configureTableView()
    }
    
    // View가 화면에 모두 나타난 뒤 이벤트 실행(alert 관련 문제)
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        vm.action.onNext(.fetchInfo)
    }
    
    // 테이블 뷰 셀 등록
    private func configureTableView(){
        mainView.rateTableView.register(ExchangeRateCell.self, forCellReuseIdentifier: ExchangeRateCell.idenfier)
    }
    
    // ViewModel간의 데이터 바인딩
    private func bindViewModel(){
        // API 데이터 fetch
        vm.state.responseData
            .observe(on: MainScheduler.instance)
            .catch{ [weak self] error in
                guard let error = error as? DataError, let self else { return Observable.empty() }
                showAlert(type: error)
                return Observable.empty()
            }
            .bind(to: mainView.rateTableView.rx.items(
                cellIdentifier: ExchangeRateCell.idenfier,
                cellType: ExchangeRateCell.self)){ _, response, cell in
                    cell.configure(response: response)
            }
            .disposed(by: disposeBag)
        
    }
}


