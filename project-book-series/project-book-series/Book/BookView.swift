//
//  BookView.swift
//  project-book-series
//
//  Created by 유영웅 on 3/24/25.
//

import Foundation
import UIKit

//MARK: BookView
//UI요소 분리
final class BookView:UIView{
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

#Preview{
    BookViewController()
}
