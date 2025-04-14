//
//  Extension+UIViewController.swift
//  project-exchange-rate-calculator
//
//  Created by 유영웅 on 4/14/25.
//

import Foundation
import UIKit
import RxSwift

//MARK: UIViewController - 전역 메서드
extension UIViewController{
    // 에러 alert 표시
    func showAlert(type: DataError) {
        let alert = UIAlertController(title: "에러", message: type.rawValue, preferredStyle: .alert)
        let confirm = UIAlertAction(title: "확인", style: .default)
        alert.addAction(confirm)
        present(alert, animated: true)
    }
}
