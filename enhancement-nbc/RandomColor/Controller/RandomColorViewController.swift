//
//  RandomColorViewController.swift
//  enhancement-nbc
//
//  Created by 유영웅 on 2/17/25.
//

import UIKit

class RandomColorViewController: UIViewController {
    
    var color = Color()
    let colorView = RandomColorView()
    
    override func loadView() {
        view = colorView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupActions()
        update()
    }
    
    private func setupActions() {
        colorView.changeButton.addTarget(self, action: #selector(changeColor), for: .touchUpInside)
        colorView.resetButton.addTarget(self, action: #selector(resetColor), for: .touchUpInside)
    }
    
    private func update() {
        view.backgroundColor = color.randomColor
        colorView.rgbText.text = color.text
    }
    
    @objc func changeColor() {
        color.getRandomColor()
        update()
    }
    
    @objc func resetColor() {
        color.resetColor()
        update()
    }
}

#Preview{
    RandomColorViewController()
}
