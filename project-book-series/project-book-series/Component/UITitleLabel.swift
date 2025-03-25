//
//  UITitleLabel.swift
//  project-book-series
//
//  Created by 유영웅 on 3/25/25.
//

import Foundation
import UIKit

//MARK: View의 라벨 중 타이틀에 해당하는 커스텀 컴포넌트
class UITitleLabel:UILabel{
    let texts:String?
    let size:CGFloat
    
    init(texts:String? = nil,size:CGFloat) {
        self.size = size
        self.texts = texts
        super.init(frame: .zero)
        configure()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func configure(){
        text = texts
        font = .boldSystemFont(ofSize: size)
        textColor = .black
        numberOfLines = 0
        textAlignment = .center
    }
}
