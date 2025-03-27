//
//  ViewController.swift
//  project-book-series
//
//  Created by 유영웅 on 3/24/25.
//

import UIKit

//MARK: BookViewController
//View와 관련된 이벤트를 처리
final class BookViewController: UIViewController{

    private let bookView = BookView()
    
    //MARK: Alert 생성
    public let alert:UIAlertController = {
        let alert = UIAlertController(title: "Error", message: nil, preferredStyle: .alert)
        let confirm = UIAlertAction(title: "Confirm", style: .default)
        alert.addAction(confirm)
        return alert
    }()
    
    override func loadView() {
        view = bookView
    }
    override func viewDidLoad() {
        view.backgroundColor = .white
        super.viewDidLoad()
        fetchInfo()
    }
    //MARK: json 인코딩 성공 후 View 데이터 세팅
    private func fetchInfo(){
        Task{
            do{
                let data = try await JsonManager.loadJson().get()
                bookView.isHidden = false
                bookView.config(attributes: data)
            }catch let error{
                guard let dataError = error as? DataError else {return}
                bookView.isHidden = true
                alert.message = dataError.rawValue
                present(alert, animated: true)
            }
        }
    }
}

#Preview{
    BookViewController()
}
