//
//  UISectionStackView.swift
//  project-book-series
//
//  Created by 유영웅 on 3/25/25.
//

import Foundation
import UIKit

//MARK: 커스텀 타이르/컨텐츠 스택 뷰
class UIArticleStackView:UIStackView{
    //MARK: 타이틀
    let title:String
    //MARK: 컨텐츠 변경 시 텍스트 업데이트
    var content:String?{
        didSet{
            configure()
        }
    }
    //MARK: 컨텐츠 리스트 변경 시 스택뷰 업데이트
    var contents:[String]?{
        didSet{
            configure()
        }
    }
    //MARK: 타이틀 라벨
    private lazy var titleLabel = UITitleLabel(texts: title, size: 18)
    //MARK: 컨텐츠 라벨
    private lazy var contentLabel = UIContentLabel(fonts: .systemFont(ofSize: 14), color: .darkGray)
    //MARK: 컨텐츠 리스트 스택뷰
    private lazy var contentStackView:UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .leading
        view.spacing = 8
        return view
    }()
    
    init(title:String) {
        self.title = title
        super.init(frame: .zero)
        axis = .vertical
        spacing = 8
        alignment = .leading
        addArrangedSubview(titleLabel)
        addArrangedSubview(contentLabel)
        addArrangedSubview(contentStackView)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: 단일 컨텐츠의 경우 text교체/리스트일 경우 스택뷰에서 전부 제거 후 새로 추가
    private func configure(){
        if let content {
            contentLabel.text = content
        } else if let contents {
            contentStackView.arrangedSubviews
                .forEach {
                    removeArrangedSubview($0)
                    $0.removeFromSuperview()
                }
            contents.forEach {
                contentStackView.addArrangedSubview(UIContentLabel(fonts: .systemFont(ofSize: 14), color: .darkGray,text: $0))
            }
        }
    }
}
