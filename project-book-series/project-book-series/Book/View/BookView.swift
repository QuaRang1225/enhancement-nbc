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
    
    //MARK: 컴포넌트
    public let posterImageView:UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleToFill
        view.isUserInteractionEnabled = true
        return view
    }()
    private let scrollView:UIScrollView = {
        let view = UIScrollView()
        view.isScrollEnabled = true
        view.showsVerticalScrollIndicator = false
        return view
    }()
    private lazy var bookInfoHStackView:UIStackView = {
        let view = UIStackView(arrangedSubviews: [posterImageView,bookInfoVStackView])
        view.axis = .horizontal
        view.alignment = .top
        view.spacing = 16
        return view
    }()
    private lazy var bookInfoVStackView:UIStackView = {
        let view = UIStackView(arrangedSubviews: [bookTitleLabel,authorTitleLabel,realesTitleLabel,pageTitleLabel])
        view.axis = .vertical
        view.alignment = .leading
        view.spacing = 8
        return view
    }()
    public lazy var contentsVStackView:UIStackView = {
        let view = UIStackView(arrangedSubviews: [dedicationStackView,summaryStackView,chapterStackView])
        view.axis = .vertical
        view.alignment = .leading
        view.spacing = 24
        return view
    }()
    public let expandButton:UIButton = {
        let button = UIButton()
        button.setTitle("더보기", for: .normal)
        button.setTitle("접기", for: .selected)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.contentHorizontalAlignment = .trailing
        return button
    }()
    public let seriesCollectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width:40, height: 40)
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.isScrollEnabled = false
        view.contentMode = .center
        view.backgroundColor = .white
        view.showsHorizontalScrollIndicator = false
        view.register(UIEpisodeCell.self, forCellWithReuseIdentifier: UIEpisodeCell.identifier)
        return view
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        configureSubViews()
        configureLayout()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: 컴포넌트 추가
    private func configureSubViews(){
        [scrollContentView]
            .forEach{ scrollView.addSubview($0) }
        [titleLabel,seriesCollectionView,scrollView]
            .forEach{ addSubview($0) }
        [bookInfoHStackView,authorLabel,realesLabel,pageLabel,contentsVStackView]
            .forEach{ scrollContentView.addSubview($0) }
        summaryStackView.addArrangedSubview(expandButton)
    }
    //MARK: 컴포넌트 및 레이아웃 설정
    private func configureLayout(){
        //타이틀
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(10)
            make.centerX.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        //시리즈 컬렉션 버튼
        seriesCollectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.height.equalTo(45)
            make.horizontalEdges.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        //스크롤뷰
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(seriesCollectionView.snp.bottom).offset(5)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
            make.bottom.equalToSuperview()
        }
        //스크롤 컨텐츠뷰
        scrollContentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        //포스터 이미지
        posterImageView.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.height.equalTo(posterImageView.snp.width).multipliedBy(1.5)
        }
        //작가
        authorLabel.snp.makeConstraints { make in
            make.centerY.equalTo(authorTitleLabel)
            make.leading.equalTo(authorTitleLabel.snp.trailing).offset(8)
        }
        //집전일
        realesLabel.snp.makeConstraints { make in
            make.centerY.equalTo(realesTitleLabel)
            make.leading.equalTo(realesTitleLabel.snp.trailing).offset(8)
        }
        //페이지 수
        pageLabel.snp.makeConstraints { make in
            make.centerY.equalTo(pageTitleLabel)
            make.leading.equalTo(pageTitleLabel.snp.trailing).offset(8)
        }
        //책 정보 스택
        bookInfoHStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(19)
            make.horizontalEdges.equalToSuperview()
        }
        //dedication & Summary & Chpaters 스택뷰
        contentsVStackView.snp.makeConstraints { make in
            make.top.equalTo(bookInfoHStackView.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview().offset(-20)
        }
        //더보기 버튼
        expandButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
        }
    }
    //attributes 데이터 각 컴포넌트에 설정
    public func config(attributes:[Attributes], episode:Int){
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




