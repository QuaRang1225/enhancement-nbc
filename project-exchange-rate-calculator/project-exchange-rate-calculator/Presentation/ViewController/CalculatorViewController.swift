//
//  CalculatorViewController.swift
//  project-exchange-rate-calculator
//
//  Created by 유영웅 on 4/16/25.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

// MARK: 환율 계산기 컨트롤러
final class CalculatorViewController: UIViewController {
    
    public let calculatorView = CalculatorView()
    private let vm = CalculatorViewModel()
    private var disposeBag = DisposeBag()
    private let id: UUID
    
    
    init(id: UUID) {
        self.id = id
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = calculatorView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        bindViewModel()
    }
    
    // ViewModel과 바인딩
    private func bindViewModel() {
        
        // MARK: 입력 VC -> VM -> Model
        
        // 환율 데이터 요청
        vm.action.onNext(.fecthExchageRate(id: id))
        
        // 데이터 입력 후 버튼 터치 시 값 액션 방출
        calculatorView.convertButton.rx.tap
            .observe(on: MainScheduler.instance)
            .withLatestFrom(calculatorView.amountTextField.rx.text.orEmpty)
            .subscribe(with: self) { owner, text in
                guard !text.isEmpty else {                                  //값이 비었을 경우
                    return owner.showAlert(type: TextFieldCase.isEmpty)
                }
                guard let input = Double(text) else {                       //숫자가 아닐 경우
                    return owner.showAlert(type: TextFieldCase.isNotDouble)
                }
                owner.vm.action.onNext(.calculate(input: input))
            }
            .disposed(by: disposeBag)
        
        // MARK: 출력 VM -> VC -> View
        
        // fetch 로드된 데이터 적용
        vm.state.exchageRate
            .observe(on: MainScheduler.instance)
            .subscribe(with: self) { owner, response in
                guard let response else { return }
                owner.calculatorView.configure(response: response)
            }
            .disposed(by: disposeBag)
        
        // 환율 계산된 데이터 적용
        vm.state.calculatedRate
            .bind(to: calculatorView.resultLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
