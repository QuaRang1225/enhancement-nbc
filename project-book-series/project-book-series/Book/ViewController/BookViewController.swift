//
//  ViewController.swift
//  project-book-series
//
//  Created by 유영웅 on 3/24/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

//MARK: BookViewController
//View와 관련된 이벤트를 처리
final class BookViewController: UIViewController{
    
    //MARK: BookView
    private var bookView = BookView()
    //MARK: viewModel
    private let vm = BookViewModel()
    //MARK: disposeBag
    private let disposeBag = DisposeBag()
    //MARK: 데이터 바인딩
    //버튼 정보
    private var episode:Int = UserDefaultsManagar.shared.getData(mode: .episode) {
        willSet{
            UserDefaultsManagar.shared.setData(mode: .episode, value: newValue)
        }
    }
    //더보기/접기 여부
    private var isExpand:Bool = UserDefaultsManagar.shared.getData(mode: .expand) {
        willSet{
            UserDefaultsManagar.shared.setData(mode: .expand, value: newValue)
        }
    }
    //MARK: 연산 프로퍼티
    //Summary 문자열의 길이에 따라 분류(text:450자, cut: 451~자,cutCount)
    private var translateSummary:String{
        let text = vm.attributes[episode].summary
        let summary = String(text.prefix(450))
        let cut = String(text.dropFirst(450))
        
        return summary + (!(text.count > 450) ? "" : (isExpand ? cut : "..."))
    }
    public var alert:UIAlertController{
        let alert = UIAlertController(title: "Error", message: nil, preferredStyle: .alert)
        let confirm = UIAlertAction(title: "Confirm", style: .default)
        alert.addAction(confirm)
        return alert
    }
    //MARK: view life cycle
    //데이터 가져오기 전까지 bookView 숨김
    override func loadView() {
        super.loadView()
        view = bookView
        bookView.isHidden = true
    }
    //바인딩 + 타겟설정
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        configureTarget()
    }
    //레이아웃 변경 시 컬렉션 뷰 업데이트
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        bookView.seriesCollectionView.collectionViewLayout.invalidateLayout()
    }
    //MARK: VC 메서드
    //뷰 바인딩
    private func bindViewModel() {
        vm.fetchSubject
            .onNext((bookView.isHidden = false))
        vm.attributesSubject
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] attributes in
                self?.configureBookView(attributes)
                self?.configureCollectionViewDelegate()
                self?.configureExpandButton()
                self?.configureSummaryStackView()
            },onError: { [weak self] error in
                guard let dataError = error as? DataError else { return }
                self?.showError(dataError)
            })
            .disposed(by: disposeBag)
    }
    //데이터 fetch 성공시 BookView 관련 설정
    private func configureBookView(_ attributes:[Attributes]){
        bookView.config(attributes: vm.attributes, episode: episode)
    }
    //bookView 컬렉션뷰 델리게이트 설정
    private func configureCollectionViewDelegate(){
        bookView.seriesCollectionView.delegate = self
        bookView.seriesCollectionView.dataSource = self
    }
    // Error 처리
    private func showError(_ error: DataError) {
        bookView.isHidden = true
        alert.message = error.rawValue
        present(alert, animated: true)
    }
    //더보기 버튼 세팅
    private func configureExpandButton(){
        let summary = vm.attributes[episode].summary
        bookView.expandButton.isHidden = !(summary.count > 450)
        bookView.expandButton.isSelected = isExpand
    }
    //summary 내용 세팅
    private func configureSummaryStackView(){
        bookView.summaryStackView.content = translateSummary
    }
    //버튼 타켓 설정
    private func configureTarget(){
        bookView.expandButton.addTarget(self, action: #selector(toggleSummaryExpand), for: .touchUpInside)
        bookView.posterImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(presentWebView)))
    }
    //MARK: 버튼 이벤트 메서드
    //summary 더보기
    @objc private func toggleSummaryExpand(){
        isExpand.toggle()
        bookView.expandButton.isSelected.toggle()
        configureSummaryStackView()
    }
    //포스터 이미지 터치
    @objc private func presentWebView(){
        let vc = WikiWebView(url: URL(string: vm.attributes[episode].wiki)!)
        vc.modalPresentationStyle = .formSheet
        present(vc, animated: true)
    }
}

//MARK: 컬렉션뷰 컨트롤러 델리게이트
extension BookViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    //MARK: 컬렉션 뷰 개수 반환
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        vm.attributes.count
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
        configureBookView(vm.attributes)
        configureSummaryStackView()
        configureExpandButton()
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
