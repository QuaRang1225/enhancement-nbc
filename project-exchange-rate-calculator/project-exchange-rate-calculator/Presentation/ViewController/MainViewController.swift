//
//  ViewController.swift
//  project-exchange-rate-calculator
//
//  Created by 유영웅 on 4/14/25.
//

import UIKit
import RxSwift
import RxCocoa

// MARK: 메인 컨트롤러
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
        view.backgroundColor = .customBackgroundColor
        configureTableView()
        configureNavigation()
        bindViewModel()
    }
    
    // 네비게이션 타이틀 설정
    private func configureNavigation() {
        navigationItem.title = "환율 정보"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
    }
    
    // 테이블 뷰 셀 등록
    private func configureTableView() {
        mainView.rateTableView.register(ExchangeRateCell.self, forCellReuseIdentifier: ExchangeRateCell.idenfier)
    }
    
    // ViewModel간의 데이터 바인딩
    private func bindViewModel() {
        
        // MARK: View Event
        
        // 검색 텍스트 변경 마다 이벤트 발출
        mainView.searchBar.rx.text
            .orEmpty
            .distinctUntilChanged()
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, text in
                owner.vm.action.onNext(.searchText(text: text))
            }, onError: { owner, error in
                guard let error = error as? DataError else { return }
                owner.showAlert(type: error)
            })
            .disposed(by: disposeBag)
        
        // 셀 터치 시 이벤트 방출
        mainView.rateTableView.rx
            .modelSelected(ExchangeRateModel.self)
            .bind(with: self) { owner, response in
                let vc = CalculatorViewController(id: response.id)
                owner.navigationItem.backBarButtonItem = UIBarButtonItem(title: "환율 정보", style: .plain, target: nil, action: nil)
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        // MARK: 입력 VC -> VM -> Model
        
        //  API 데이터 fetch
        vm.action.onNext(.fetchInfo)
        
        // MARK: 출력 VM -> VC -> View
        
        // fetchData 리스트로 테이블뷰 cell 컴포넌트 데이터 설정
        vm.state.filteredExchangeRates
            .observe(on: MainScheduler.instance)
            .map {
                let alphabetSorted = $0.sorted { $0.currency < $1.currency }
                return alphabetSorted.sorted { $0.isBookmark && !$1.isBookmark }
            }
            .do { [weak self] list in
                self?.mainView.emptyLabel.isHidden = !list.isEmpty
            }
            .bind(to: mainView.rateTableView.rx.items(
                cellIdentifier: ExchangeRateCell.idenfier,
                cellType: ExchangeRateCell.self)
            ) { (_, response, cell) in
                cell.configure(response: response)
                cell.delegate = self
            }
            .disposed(by: disposeBag)
    }
}

extension MainViewController: ExchangeRateCellDelegate {
    func touchBookmark(model: ExchangeRateModel) {
        vm.action.onNext(.bookmark(model: model))
    }
}
