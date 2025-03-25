//
//  UISectionStackView.swift
//  project-book-series
//
//  Created by 유영웅 on 3/25/25.
//

import Foundation
import UIKit

//MARK: 커스텀 섹션뷰 셍성
class UISectionStackView: UIStackView {
    
    init(axis: NSLayoutConstraint.Axis, spacings:CGFloat, views: [UIView]) {
        super.init(frame: .zero)
        self.axis = axis
        self.alignment = .leading
        self.spacing = spacings
        views.forEach { self.addArrangedSubview($0) }
    }
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
