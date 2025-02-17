//
//  UIButton.swift
//  enhancement-nbc
//
//  Created by 유영웅 on 2/17/25.
//

import Foundation
import UIKit

extension UIButton{
    func counterModifier()->UIButton{
        self.titleLabel?.font = .systemFont(ofSize: 25)
        self.setTitleColor(.label, for: .normal)
        self.translatesAutoresizingMaskIntoConstraints = false
        return self
    }
}
