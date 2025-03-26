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
    private var bookView:BookView?
    
    //MARK: Alert 생성
    public let alert:UIAlertController = {
        let alert = UIAlertController(title: "Error", message: nil, preferredStyle: .alert)
        let confirm = UIAlertAction(title: "Confirm", style: .default)
        alert.addAction(confirm)
        return alert
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchInfo()
    }
    //MARK: json 인코딩 성공 후 View 데이터 세팅
    private func fetchInfo(){
        Task{
            do{
                let data = try await JsonManager.loadJson().get()
                bookView = BookView(attributes: data)
                bookView?.delegate = self
                bookView?.config()
                configureTarget()
                view = bookView
            }catch let error{
                guard let dataError = error as? DataError else {return}
                alert.message = dataError.rawValue
                present(alert, animated: true)
            }
        }
    }
    //MARK: 버튼 타켓 설정
    private func configureTarget(){
        bookView?.expandButton.addTarget(self, action: #selector(toggleSummaryExpand), for: .touchUpInside)
    }
    //MARK: summary 더보기 버튼 이벤트
    @objc private func toggleSummaryExpand(){
        isExpand.toggle()
        bookView?.summaryLabel.text?.removeLast(isExpand ? 3 : bookView?.summaryTuple.cutCount ?? 0)
        bookView?.summaryLabel.text?.append(isExpand ? bookView?.summaryTuple.cut ?? "": "...")
        bookView?.expandButton.setTitle(isExpand ? "접기" : "더보기", for: .normal)
    }
    //MARK: 에피소드 버튼 터치 이벤트
    @objc private func setEpisodeInfo(_ gesture:SelecteEpisodeGesture){
        bookView?.episode = gesture.episode
        isExpand = false
        bookView?.update()
    }
}

#Preview{
    BookViewController()
}

extension BookViewController:BookViewDeleagate{
    //MARK: 버튼 생성과 함께 타겟 설정
    func didSetEpisodeButton(_ button: UIEpisodeButton) -> UIEpisodeButton {
        let gesture = SelecteEpisodeGesture(target: self, action: #selector(setEpisodeInfo))
        gesture.episode = button.tag
        button.addGestureRecognizer(gesture)
        return button
    }
}
