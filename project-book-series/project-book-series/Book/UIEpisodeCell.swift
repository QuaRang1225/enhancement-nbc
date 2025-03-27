//
//  UIEpisodeCell.swift
//  project-book-series
//
//  Created by 유영웅 on 3/27/25.
//

import Foundation
import UIKit

//MARK: 에피소드 컬렉션 뷰 셀
class UIEpisodeCell:UICollectionViewCell{
    
    static let identifier = "UIEpisodeCell"
    //MARK: 타이틀 라벨
    private let titleLabel:UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    override init(frame:CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        layer.cornerRadius = 20
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: 타이틀 라벨 텍스트 변경
    func config(episode:Int){
        titleLabel.text = "\(episode+1)"
    }
    //MARK: 에피소드 버튼 선택 시 실행 이벤트
    func selectedButton(_ selected:Bool){
        backgroundColor = selected ? .systemBlue : .lightGray.withAlphaComponent(0.5)
        titleLabel.textColor = selected ? .white : .systemBlue
    }
}
