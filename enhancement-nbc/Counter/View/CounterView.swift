//
//  CounterView.swift
//  enhancement-nbc
//
//  Created by 유영웅 on 2/17/25.
//

import Foundation
import UIKit
import SwiftUI 

class CounterView:UIView{
    let timeText:UILabel={
        let label = UILabel()
        label.text = "0"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let plusButton:UIButton={
        let button = UIButton()
        button.setTitle("+", for: .normal)
        return button.counterModifier()
    }()
    let minusButton:UIButton={
        let button = UIButton()
        button.setTitle("-", for: .normal)
        return button.counterModifier()
    }()
    let resetButton:UIButton={
        let button = UIButton()
        button.setTitle("reset", for: .normal)
        return button.counterModifier()
    }()
    lazy var stackView:UIStackView = {
        let view = UIStackView(arrangedSubviews: [minusButton,resetButton ,plusButton])
        view.axis = .horizontal
        view.distribution = .equalSpacing
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    func configureLayout(){
        NSLayoutConstraint.activate([
            timeText.centerXAnchor.constraint(equalTo: centerXAnchor),
            timeText.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            stackView.leftAnchor.constraint(equalTo: leftAnchor,constant: 60),
            stackView.rightAnchor.constraint(equalTo: rightAnchor,constant: -60),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor,constant: -30)
        ])
    }
    func configureView(){
        [timeText,stackView].forEach{ addSubview($0) }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


#Preview {
    UIViewPreview(CounterView()).ignoresSafeArea()
}



