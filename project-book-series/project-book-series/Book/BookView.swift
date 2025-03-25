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
    
    public var summaryTuple:(text:String,cut:String,cutCount:Int) = ("","",0)
    
    //MARK: 스크롤뷰에 담을 뷰
    private let scrollContentView = UIView()
    
    //MARK: Dedication & Summary 섹션 스택뷰
    private lazy var dedication  = UISectionStackView(axis: .vertical, spacings: 8, views: [dedicationTitleLabel,dedicationLabel])
    private lazy var summary = UISectionStackView(axis: .vertical, spacings: 8, views: [summaryTitleLabel,summaryLabel,expandButton])
    
    //MARK: 타이틀 라벨
    private let titleLabel = UITitleLabel(size: 24)
    private let bookTitleLabel = UITitleLabel(size: 20)
    private let authorTitleLabel = UITitleLabel(texts: "Author",size: 16)
    private let realesTitleLabel = UITitleLabel(texts: "Released", size: 14)
    private let pageTitleLabel = UITitleLabel(texts: "Page",size: 14)
    private let dedicationTitleLabel = UITitleLabel(texts: "Dedication", size: 18)
    private let summaryTitleLabel = UITitleLabel(texts: "Summary", size: 18)
    private let chaptersTitleLabel = UITitleLabel(texts: "Chapters", size: 18)
    
    //MARK: 각 타이틀에 따른 데이터 라벨
    private let authorLabel = UIContentLabel(fonts: .systemFont(ofSize: 18), color: .darkGray)
    private let realesLabel = UIContentLabel(fonts: .systemFont(ofSize: 14), color: .gray)
    private let pageLabel = UIContentLabel(fonts: .systemFont(ofSize: 14), color: .gray)
    private let dedicationLabel = UIContentLabel(fonts: .systemFont(ofSize: 14), color: .darkGray)
    public let summaryLabel = UIContentLabel(fonts: .systemFont(ofSize: 14), color: .darkGray)
    
    //MARK: 시리즈 순서
    private let seriesButton:UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 20
        button.titleLabel?.font = .systemFont(ofSize: 16)
        return button
    }()
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
    //MARK: Alert 생성
    public let alert:UIAlertController = {
        let alert = UIAlertController(title: "Error", message: nil, preferredStyle: .alert)
        let confirm = UIAlertAction(title: "Confirm", style: .default)
        alert.addAction(confirm)
        return alert
    }()
    //MARK: 더보기 버튼
    public lazy var expandButton:UIButton = {
        let button = UIButton()
        button.setTitle("더보기", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.contentHorizontalAlignment = .right
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: 컴포넌트 및 레이아웃 설정
    private func configureUI(){
        
        scrollView.addSubview(scrollContentView)
        [titleLabel,seriesButton,scrollView]
            .forEach{ addSubview($0) }
        [bookInfoHStackView,authorLabel,realesLabel,pageLabel]
            .forEach{ scrollContentView.addSubview($0) }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(10)
            make.centerX.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        seriesButton.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.width.height.equalTo(40)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(scrollView.snp.top).offset(-5)
        }
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(seriesButton.snp.bottom)
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
    }
    //MARK: json 인코딩 성공 시 데이터 세팅
    public func config(attributes:[Attributes]){
        let index = 0
        titleLabel.text = attributes[index].title
        seriesButton.setTitle("\(index+1)", for: .normal)
        posterImageView.image = UIImage(named: "harrypotter\(index+1)")
        bookTitleLabel.text = attributes[index].title
        authorLabel.text = attributes[index].author
        realesLabel.text = attributes[index].releaseDate.getAmericaDateFormatter()
        pageLabel.text = "\(attributes[index].pages)"
        dedicationLabel.text = attributes[index].dedication
        
        expandString(text: attributes[index].summary)
        configChapters(chapters: attributes[index].chapters)
    }
    //MARK: 챕터 라벨 리스트 생성 후 다른 섹션과 함께 scrollContentView에 추가
    private func configChapters(chapters:[Chapter]){
        let labels = chapters.map{
            let label = UIContentLabel(fonts: .systemFont(ofSize: 14), color: .darkGray)
            label.text = $0.title
            return label
        }
        let chapters = UISectionStackView(axis: .vertical, spacings: 8, views: [chaptersTitleLabel] + labels)
        let sections = UISectionStackView(axis: .vertical, spacings: 24, views: [dedication,summary,chapters])
        
        scrollContentView.addSubview(sections)
        
        sections.snp.makeConstraints { make in
            make.top.equalTo(bookInfoHStackView.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().offset(-20)
        }
        expandButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
        }
    }
    //MARK: 문자열의 길이가 450이상일 경우
    private func expandString(text:String){
        let cut = String(text.dropFirst(450))
        summaryTuple.text = String(text.prefix(450))
        summaryTuple.cut = cut
        summaryTuple.cutCount = cut.count
        if text.count > 450{
            summaryTuple.text.append("...")
        }else{
            expandButton.isHidden = true
        }
        summaryLabel.text = summaryTuple.text
    }
}

#Preview{
    BookViewController()
}


