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
    
    //MARK: 더보기/접기 여부
    private var isExpand = false
    //MARK: BookView
    private var bookView = BookView()
    //MARK: Summary 문자열의 길이에 따라 분류(text:450자, cut: 451~자,cutCount)
    public var summaryTuple:(text:String,cut:String,cutCount:Int) = ("","",0)
    
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
        let text = bookView.attributes[bookView.episode].summary
        let cut = String(text.dropFirst(450))
        summaryTuple.text = String(text.prefix(450))
        summaryTuple.cut = cut
        summaryTuple.cutCount = cut.count
        if text.count > 450{
            bookView.expandButton.isHidden = false
            summaryTuple.text.append("...")
        }else{
            bookView.expandButton.isHidden = true
        }
        bookView.summaryStackView.content = summaryTuple.text
    }
    //MARK: 버튼 타켓 설정
    private func configureTarget(){
        bookView.expandButton.addTarget(self, action: #selector(toggleSummaryExpand), for: .touchUpInside)
    }
    //MARK: summary 더보기 버튼 이벤트
    @objc private func toggleSummaryExpand(){
        isExpand.toggle()
        bookView.summaryStackView.content?.removeLast(isExpand ? 3 : summaryTuple.cutCount)
        bookView.summaryStackView.content?.append(isExpand ? summaryTuple.cut : "...")
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
        cell.selectedButton(indexPath.row == bookView.episode)
        return cell
    }
    //MARK: 컬렉션 뷰 선택 시 이벤트 설정
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        isExpand = false
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
