//
//  BookView.swift
//  project-book-series
//
//  Created by 유영웅 on 3/24/25.
//

import Foundation
import UIKit
import SnapKit

//MARK: BookView
//UI요소 분리
final class BookView:UIView{
    
    //MARK: 속성 배열
    public var attributes = [Attributes]()
    //MARK: 스크롤뷰에 담을 뷰
    private let scrollContentView = UIView()
    
    //MARK: 타이틀 라벨
    private let titleLabel = UITitleLabel(size: 24)
    private let bookTitleLabel = UITitleLabel(size: 20)
    private let authorTitleLabel = UITitleLabel(text: "Author",size: 16)
    private let realesTitleLabel = UITitleLabel(text: "Released", size: 14)
    private let pageTitleLabel = UITitleLabel(text: "Page",size: 14)
    
    //MARK: 각 타이틀에 따른 데이터 라벨
    private let authorLabel = UIContentLabel(font: .systemFont(ofSize: 18), color: .darkGray)
    private let realesLabel = UIContentLabel(font: .systemFont(ofSize: 14), color: .gray)
    private let pageLabel = UIContentLabel(font: .systemFont(ofSize: 14), color: .gray)
    
    //MARK: Title & Content 스택 뷰
    private let dedicationStackView = UIArticleStackView(title: "Dedication")
    public let summaryStackView = UIArticleStackView(title: "Summary")
    private let chapterStackView = UIArticleStackView(title: "Chapters")
    
    //MARK: 포스터 이미지
    private let posterImageView:UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleToFill
        return view
    }()
    //MARK: 스크롤뷰
    private let scrollView:UIScrollView = {
        let view = UIScrollView()
        view.isScrollEnabled = true
        view.showsVerticalScrollIndicator = false
        return view
    }()
    //MARK: 해당 에피소드 작품 Horizontal 스택뷰
    private lazy var bookInfoHStackView:UIStackView = {
        let view = UIStackView(arrangedSubviews: [posterImageView,bookInfoVStackView])
        view.axis = .horizontal
        view.alignment = .top
        view.spacing = 16
        return view
    }()
    //MARK: 해당 에피소드 작품 Vertical 스택뷰
    private lazy var bookInfoVStackView:UIStackView = {
        let view = UIStackView(arrangedSubviews: [bookTitleLabel,authorTitleLabel,realesTitleLabel,pageTitleLabel])
        view.axis = .vertical
        view.alignment = .leading
        view.spacing = 8
        return view
    }()
    //MARK: 책 내용 관련 스택뷰
    public lazy var contentsVStackView:UIStackView = {
        let view = UIStackView(arrangedSubviews: [dedicationStackView,summaryStackView,chapterStackView])
        view.axis = .vertical
        view.alignment = .leading
        view.spacing = 24
        return view
    }()
    //MARK: 더보기 버튼
    public let expandButton:UIButton = {
        let button = UIButton()
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.contentHorizontalAlignment = .right
        return button
    }()
    //MARK: 시리즈 컬렉션 뷰
    public let seriesCollectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width:40, height: 40)
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.contentMode = .center
        view.backgroundColor = .white
        view.showsHorizontalScrollIndicator = false
        view.register(UIEpisodeCell.self, forCellWithReuseIdentifier: UIEpisodeCell.identifier)
        return view
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        configureUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: 컴포넌트 및 레이아웃 설정
    private func configureUI(){
        
        [scrollContentView]
            .forEach{ scrollView.addSubview($0) }
        [titleLabel,seriesCollectionView,scrollView]
            .forEach{ addSubview($0) }
        [bookInfoHStackView,authorLabel,realesLabel,pageLabel,contentsVStackView,expandButton]
            .forEach{ scrollContentView.addSubview($0) }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(10)
            make.centerX.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        seriesCollectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.height.equalTo(45)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.centerX.equalToSuperview()
        }
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(seriesCollectionView.snp.bottom).offset(5)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        scrollContentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        posterImageView.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.height.equalTo(150)
        }
        authorLabel.snp.makeConstraints { make in
            make.centerY.equalTo(authorTitleLabel)
            make.leading.equalTo(authorTitleLabel.snp.trailing).offset(8)
        }
        realesLabel.snp.makeConstraints { make in
            make.centerY.equalTo(realesTitleLabel)
            make.leading.equalTo(realesTitleLabel.snp.trailing).offset(8)
        }
        pageLabel.snp.makeConstraints { make in
            make.centerY.equalTo(pageTitleLabel)
            make.leading.equalTo(pageTitleLabel.snp.trailing).offset(8)
        }
        bookInfoHStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(19)
            make.horizontalEdges.equalTo(titleLabel)
        }
        contentsVStackView.snp.makeConstraints { make in
            make.top.equalTo(bookInfoHStackView.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().offset(-20)
        }
        expandButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.top.equalTo(summaryStackView.snp.bottom)
        }
    }
    //MARK: 속성 데이터 업데이트
    public func configAttributes(attributes:[Attributes]){
        self.attributes = attributes
    }
    //MARK: json 인코딩 성공 시 데이터 세팅
    public func config(episode:Int){
        titleLabel.text = attributes[episode].title
        posterImageView.image = UIImage(named: "harrypotter\(episode+1)")
        bookTitleLabel.text = attributes[episode].title
        authorLabel.text = attributes[episode].author
        realesLabel.text = attributes[episode].releaseDate.getAmericaDateFormatter()
        pageLabel.text = "\(attributes[episode].pages)"
        
        dedicationStackView.content = attributes[episode].dedication
        chapterStackView.contents = attributes[episode].chapters.map{ $0.title }
        
        seriesCollectionView.reloadData()
    }
}

#Preview{
    BookViewController()
}




