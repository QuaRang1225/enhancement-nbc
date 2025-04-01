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
    //MARK: 버튼 정보
    private var episode = 0
    //MARK: BookView
    private let bookView = BookView()
    //MARK: Summary 문자열의 길이에 따라 분류(text:450자, cut: 451~자,cutCount)
    private var summaryAttributes = SummaryAttributes()
    
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
        configureTarget()
    }
    //MARK: json 인코딩 성공 후 View 데이터 세팅
    private func fetchInfo(){
        Task{
            do{
                let data = try await JsonManager.loadJson().get()
                bookView.configAttributes(attributes: data)
                bookView.config(episode: episode)
                configExpandString()
                configureTarget()
            }catch let error{
                guard let dataError = error as? DataError else {return}
                alert.message = dataError.rawValue
                present(alert, animated: true)
            }
        }
    }
    //MARK: 문자열을 종류별로 분리해 더보기 기능 구현
    private func configExpandString(){
        let text = bookView.attributes[episode].summary
        let summary = String(text.prefix(450))
        let cut = String(text.dropFirst(450))
        if text.count > 450{
            bookView.expandButton.isHidden = false
            summaryAttributes = SummaryAttributes(text: summary + (isExpand ? cut : "..."),cut: cut)
        }else{
            bookView.expandButton.isHidden = true
            summaryAttributes = SummaryAttributes(text: text, cut: cut)
        }
        bookView.expandButton.setTitle(isExpand ? "접기" : "더보기", for: .normal)
        bookView.summaryStackView.content = summaryAttributes.text
    }
    //MARK: 버튼 타켓 설정
    private func configureTarget(){
        bookView.expandButton.addTarget(self, action: #selector(toggleSummaryExpand), for: .touchUpInside)
    }
    //MARK: summary 더보기 버튼 이벤트
    @objc private func toggleSummaryExpand(){
        isExpand.toggle()
        bookView.summaryStackView.content?.removeLast(isExpand ? 3 : summaryAttributes.cutCount)
        bookView.summaryStackView.content?.append(isExpand ? summaryAttributes.cut : "...")
        bookView.expandButton.setTitle(isExpand ? "접기" : "더보기", for: .normal)
    }
}

#Preview{
    BookViewController()
}
