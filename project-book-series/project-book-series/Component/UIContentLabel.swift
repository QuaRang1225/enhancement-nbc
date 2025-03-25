//
//  UIContentLabel.swift
//  project-book-series
//
//  Created by 유영웅 on 3/25/25.
//

import Foundation
import UIKit

//MARK: View의 라벨 중 내용에 해당하는 커스텀 컴포넌트
class UIContentLabel:UILabel{
    
    init(fonts:UIFont,color:UIColor) {
        super.init(frame: .zero)
        font = fonts
        textColor = color
        numberOfLines = 0
        textAlignment = .left
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
