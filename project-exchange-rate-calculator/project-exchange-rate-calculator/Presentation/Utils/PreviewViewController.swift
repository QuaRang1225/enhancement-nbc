//
//  PreviewViewController.swift
//  project-exchange-rate-calculator
//
//  Created by 유영웅 on 4/16/25.
//

import Foundation
import UIKit

// MARK: UIView -> UIViewController로 변환해주는 VC
class PreviewViewController: UIViewController{
    
    let customView: UIView
    
    init(customView: UIView){
        self.customView = customView
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = customView
    }
}
