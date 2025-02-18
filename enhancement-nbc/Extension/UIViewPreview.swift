//
//  UIViewPreview.swift
//  enhancement-nbc
//
//  Created by 유영웅 on 2/18/25.
//

import Foundation
import SwiftUI

struct UIViewPreview<T: UIView>: UIViewRepresentable {
    let view: T

    init(_ view: T) {
        self.view = view
    }

    func makeUIView(context: Context) -> T {
        return view
    }

    func updateUIView(_ uiView: T, context: Context) {}
}
