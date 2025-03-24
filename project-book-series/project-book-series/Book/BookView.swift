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
    
    //MARK: 타이틀
    private let titleLabel:UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 24)
        return label
    }()
    //MARK: 시리즈 순서
    private let seriesButton:UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 20
        button.titleLabel?.font = .systemFont(ofSize: 16)
        return button
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
        [titleLabel,seriesButton]
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
    }
    //MARK: json 인코딩 성공 시 데이터 세팅
    public func config(attributes:[Attributes]){
        let index = 0
        titleLabel.text = attributes[index].title
        seriesButton.setTitle("\(index+1)", for: .normal)
    }
}

#Preview{
    BookViewController()
}
