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
    
    //MARK: 타이틀 라벨
    private let titleLabel = UITitleLabel(size: 24)
    private let bookTitleLabel = UITitleLabel(size: 20)
    private let authorTitleLabel = UITitleLabel(texts: "Author",size: 16)
    private let realesTitleLabel = UITitleLabel(texts: "Released", size: 14)
    private let pageTitleLabel = UITitleLabel(texts: "Page",size: 14)
    
    //MARK: 각 타이틀에 따른 데이터 라벨
    private let authorLabel = UIContentLabel(fonts: .systemFont(ofSize: 18), color: .darkGray)
    private let realesLabel = UIContentLabel(fonts: .systemFont(ofSize: 14), color: .gray)
    private let pageLabel = UIContentLabel(fonts: .systemFont(ofSize: 14), color: .gray)
    
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: 컴포넌트 및 레이아웃 설정
    private func configureUI(){
        [titleLabel,seriesButton,bookInfoHStackView,authorLabel,realesLabel,pageLabel]
            .forEach{ addSubview($0) }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(10)
            make.centerX.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        seriesButton.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.width.height.equalTo(40)
            make.centerX.equalToSuperview()
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
            make.top.equalTo(seriesButton.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(titleLabel).inset(5)
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
    }
}

#Preview{
    BookViewController()
}


