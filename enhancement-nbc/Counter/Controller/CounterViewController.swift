//
//  CounterViewController.swift
//  enhancement-nbc
//
//  Created by 유영웅 on 2/17/25.
//

import UIKit

class CounterViewController: UIViewController {
    
    let vm = CounterViewModel()
    let counterView = CounterView()
    
    override func loadView() {
        view = counterView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupActions()
        bindingViewModel()
    }
    
    func bindingViewModel(){
        vm.completion = { [weak self] num in
            self?.counterView.timeText.text = "\(num)"
        }
    }
    func setupActions(){
        counterView.plusButton.addTarget(self, action: #selector(increaseNum), for: .touchUpInside)
        counterView.minusButton.addTarget(self, action: #selector(decreaseNum), for: .touchUpInside)
        counterView.resetButton.addTarget(self, action: #selector(reset), for: .touchUpInside)
    }
    @objc func increaseNum(){
        vm.increase()
    }
    @objc func decreaseNum(){
        vm.decrease()
    }
    @objc func reset(){
        vm.reset()
    }
}

#Preview{
    CounterViewController()
}

