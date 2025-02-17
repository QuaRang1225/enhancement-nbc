//
//  ViewController.swift
//  enhancement-nbc
//
//  Created by 유영웅 on 2/14/25.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addViewController(RandomColorViewController())
    }
        
    private func addViewController(_ child: UIViewController) {
        addChild(child)
        child.view.frame = view.bounds
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }
}

#Preview {
    ViewController()
}
