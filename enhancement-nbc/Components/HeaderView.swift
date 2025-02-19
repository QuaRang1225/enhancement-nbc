//
//  HeaderView.swift
//  enhancement-nbc
//
//  Created by 유영웅 on 2/19/25.
//

import Foundation
import UIKit

class HeaderView:UIView{
    let rightItem:UIButton={
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    let title:UILabel={
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let leftItem:UIButton={
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    init() {
        let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 100)
        super.init(frame: frame)
        addSubview(rightItem)
        addSubview(title)
        addSubview(leftItem)
        backgroundColor = .white
        configureLayout()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configureLayout(){
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            title.centerXAnchor.constraint(equalTo: centerXAnchor),
            title.centerYAnchor.constraint(equalTo: bottomAnchor,constant: -20),
            
            rightItem.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            rightItem.centerYAnchor.constraint(equalTo: bottomAnchor,constant: -20),
            
            leftItem.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            leftItem.centerYAnchor.constraint(equalTo: bottomAnchor,constant: -20)
        ])
    }
}
