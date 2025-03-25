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
    
    //MARK: 더보기/접기 여부
    private var isExpand = false
    //MARK: BookView
    private let bookView = BookView()
    
    override func loadView() {
        view = bookView
    }
    override func viewDidLoad() {
        view.backgroundColor = .white
        super.viewDidLoad()
        fetchInfo()
        configureTarget()
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
                bookView.alert.message = dataError.rawValue
                present(bookView.alert, animated: true)
            }
        }
    }
    //MARK: 버튼 타켓 설정
    private func configureTarget(){
        bookView.expandButton.addTarget(self, action: #selector(toggleSummaryExpand), for: .touchUpInside)
    }
    //MARK: summary 더보기 버튼 이벤트
    @objc private func toggleSummaryExpand(){
        isExpand.toggle()
        bookView.summaryLabel.text?.removeLast(isExpand ? 3 : bookView.summaryTuple.cutCount)
        bookView.summaryLabel.text?.append(isExpand ? bookView.summaryTuple.cut : "...")
        bookView.expandButton.setTitle(isExpand ? "접기" : "더보기", for: .normal)
    }
}

#Preview{
    BookViewController()
}
