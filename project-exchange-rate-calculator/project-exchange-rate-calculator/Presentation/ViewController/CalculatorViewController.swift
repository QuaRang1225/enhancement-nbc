//
//  CalculatorViewController.swift
//  project-exchange-rate-calculator
//
//  Created by 유영웅 on 4/16/25.
//

import Foundation
import UIKit

class CalculatorViewController: UIViewController {
    
    private let calculatorView = CalculatorView()
    
    override func loadView() {
        view = calculatorView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground 
    }
}
