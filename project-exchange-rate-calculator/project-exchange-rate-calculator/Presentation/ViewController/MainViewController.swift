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
    
    override func loadView() {
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        bindViewModel()
        configureTableView()
        vm.action.onNext(.fetchInfo)
    }
    
    private func configureTableView(){
        mainView.rateTableView.register(ExchangeRateCell.self, forCellReuseIdentifier: ExchangeRateCell.idenfier)
    }
    
    // ViewModel간의 데이터 바인딩
    private func bindViewModel(){
        // API 데이터 fetch
        vm.state.responseData
            .observe(on: MainScheduler.instance)
            .bind(to: mainView.rateTableView.rx.items(
                cellIdentifier: ExchangeRateCell.idenfier,
                cellType: ExchangeRateCell.self)){ _, response, cell in
                    cell.configure(response: response)
            }
            .disposed(by: disposeBag)
    }
}


