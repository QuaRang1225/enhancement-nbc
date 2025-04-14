//
//  MainView.swift
//  project-exchange-rate-calculator
//
//  Created by 유영웅 on 4/14/25.
//

import Foundation
import UIKit
import SnapKit

final class MainView:UIView{
    
    public let rateTableView = UITableView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureSubView()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(){
        
    }
    
    private func configureSubView(){
        [rateTableView]
            .forEach{ addSubview($0) }
    }
    
    private func configureLayout(){
        rateTableView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.width.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}
