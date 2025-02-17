//
//  RandomColorView.swift
//  enhancement-nbc
//
//  Created by 유영웅 on 2/17/25.
//

import Foundation
import UIKit

class RandomColorView: UIView {
    
    let rgbText: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let changeButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.label, for: .normal)
        button.setTitle("Change Color", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let resetButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.label, for: .normal)
        button.setTitle("Reset", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [changeButton, resetButton])
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    override init(frame: CGRect) {
        super.init(frame:frame)
        setupView()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        [rgbText, stackView].forEach { addSubview($0) }
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            rgbText.centerXAnchor.constraint(equalTo: centerXAnchor),
            rgbText.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            stackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 60),
            stackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -80),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -30)
        ])
    }
}

