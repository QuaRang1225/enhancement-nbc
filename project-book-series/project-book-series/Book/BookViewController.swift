//
//  ViewController.swift
//  project-book-series
//
//  Created by 유영웅 on 3/24/25.
//

import UIKit
import SnapKit

//MARK: BookViewController
//View와 관련된 이벤트를 처리
final class BookViewController: UIViewController{
    
    //MARK: 버튼 정보
    private var episode:Int = UserDefaults.standard.integer(forKey: "episode") {
        willSet{
            UserDefaults.standard.set(newValue, forKey: "episode")
        }
    }
    //MARK: BookView
    private var bookView = BookView()
    
    //MARK: 더보기/접기 여부
    private var isExpand:Bool = UserDefaults.standard.bool(forKey: "expand") {
        willSet{
            UserDefaults.standard.set(newValue, forKey: "expand")
        }
    }
    //MARK: Summary 문자열의 길이에 따라 분류(text:450자, cut: 451~자,cutCount)
    private var summaryAttributes:SummaryAttributes = UserDefaults.standard.object(forKey: "summary") as? SummaryAttributes ?? SummaryAttributes(){
        willSet{
            guard let value = try? JSONEncoder().encode(newValue) else { return }
            UserDefaults.standard.set(value, forKey: "summary")
        }
    }
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
        fetchInfo()
        configureTarget()
        bookView.seriesCollectionView.delegate = self
        bookView.seriesCollectionView.dataSource = self
    }
    //MARK: json 인코딩 성공 후 View 데이터 세팅
    private func fetchInfo(){
        Task{
            do{
                let data = try await JsonManager.loadJson().get()
                bookView.configAttributes(attributes: data)
                bookView.config(episode: episode)
                configExpandString()
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

//MARK: 컬렉션뷰 컨트롤러 델리게이트
extension BookViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    //MARK: 컬렉션 뷰 개수 반환
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        bookView.attributes.count
    }
    //MARK: 컬렉션 뷰 셀 설정
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UIEpisodeCell.identifier, for: indexPath) as? UIEpisodeCell else { return UICollectionViewCell() }
        cell.config(episode: indexPath.row)
        cell.selectedButton(indexPath.row == episode)
        return cell
    }
    //MARK: 컬렉션 뷰 선택 시 이벤트 설정
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        isExpand = false
        episode = indexPath.row
        bookView.update(index: indexPath.row)
        configExpandString()
    }
    //MARK: 컬렉션 뷰 가운데 정렬
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let cellWidth: Int = 40
        let cellCount = collectionView.numberOfItems(inSection: section)
        let totalCellWidth = cellWidth * cellCount
        let totalSpacing = (cellCount - 1) * 10
        let inset = (collectionView.frame.width - CGFloat(totalCellWidth) - CGFloat(totalSpacing))  / 2
        return UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
    }
}
