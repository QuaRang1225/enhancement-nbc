//
//  CounterView.swift
//  enhancement-nbc
//
//  Created by 유영웅 on 2/17/25.
//

import Foundation
import UIKit

class CounterViewController: UIViewController {
    
    var counter = Counter()
    let counterView = CounterView()
    
    override func loadView() {
        view = counterView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupActions()
        update()
    }
    func setupActions(){
        counterView.plusButton.addTarget(self, action: #selector(increaseNum), for: .touchUpInside)
        counterView.minusButton.addTarget(self, action: #selector(decreaseNum), for: .touchUpInside)
        counterView.resetButton.addTarget(self, action: #selector(reset), for: .touchUpInside)
    }
    func update(){
        counterView.timeText.text = "\(counter.num)"
    }
    @objc func increaseNum(){
        counter.increase()
        update()
    }
    @objc func decreaseNum(){
        counter.decrease()
        update()
    }
    @objc func reset(){
        counter.reset()
        update()
    }
}
