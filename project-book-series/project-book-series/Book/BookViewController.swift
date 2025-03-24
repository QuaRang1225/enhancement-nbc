//
//  ViewController.swift
//  project-book-series
//
//  Created by 유영웅 on 3/24/25.
//

import UIKit

//MARK: BookViewController
//View와 관련된 이벤트를 처리
final class BookViewController: UIViewController {
    
    private let bookView = BookView()
    
    
    override func loadView() {
        fetchInfo()
        view = bookView
    }
    override func viewDidLoad() {
        view.backgroundColor = .white
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    private func fetchInfo(){
        Task{
            let data = try await JsonManager.loadJson()
            switch data{
            case let .success(attributes):
                bookView.config(attributes: attributes)
                bookView.layoutIfNeeded()
            case let .failure(error): print(error.localizedDescription)
            }
        }
    }
}

#Preview{
    BookViewController()
}
