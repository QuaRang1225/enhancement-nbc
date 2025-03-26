//
//  UIEpisodeButton.swift
//  project-book-series
//
//  Created by 유영웅 on 3/25/25.
//

import Foundation
import UIKit
import SnapKit

class UIEpisodeButton:UIButton{
    init(tag:Int,current:Bool) {
        super.init(frame: .zero)
        self.tag = tag
        backgroundColor = current ? .systemBlue : .lightGray.withAlphaComponent(0.5)
        setTitleColor(current ? .white : .systemBlue, for: .normal)
        layer.cornerRadius = 20
        setTitle("\(tag+1)", for: .normal)
        titleLabel?.font = .systemFont(ofSize: 16)
        snp.makeConstraints { make in
            make.width.height.equalTo(40)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
