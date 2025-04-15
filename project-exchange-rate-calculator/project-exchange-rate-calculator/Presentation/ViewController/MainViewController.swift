//
//  ViewController.swift
//  project-exchange-rate-calculator
//
//  Created by 유영웅 on 4/14/25.
//

import UIKit
import RxSwift
import RxCocoa

final class MainViewController: UIViewController {
    
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
        view.backgroundColor = .systemBackground
        bindViewModel()
        configureTableView()
    }
    
    // 테이블 뷰 셀 등록
    private func configureTableView(){
        mainView.rateTableView.register(ExchangeRateCell.self, forCellReuseIdentifier: ExchangeRateCell.idenfier)
    }
    
    // ViewModel간의 데이터 바인딩
    private func bindViewModel(){
        
        vm.action.onNext(.fetchInfo)
        
        // API 데이터 fetch
        vm.state.filteredExchangeRates
            .observe(on: MainScheduler.instance)
            .bind(to: mainView.rateTableView.rx.items(
                cellIdentifier: ExchangeRateCell.idenfier,
                cellType: ExchangeRateCell.self)
            ) { _, response, cell in
                cell.configure(response: response)
            }
            .disposed(by: disposeBag)
        
        // 검색 텍스트 변경 마다
        mainView.searchBar.rx.text
            .orEmpty
            .distinctUntilChanged()
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .withUnretained(self)
            .subscribe{ owner, text in
                owner.vm.action.onNext(.searchText(text))
            }
            .disposed(by: disposeBag)
    }
}
