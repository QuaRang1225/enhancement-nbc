//
//  MainView.swift
//  project-exchange-rate-calculator
//
//  Created by 유영웅 on 4/14/25.
//

import Foundation
import UIKit
import SnapKit
import Then

// MARK: 메인화면
final class MainView:UIView{
    
    // 테이블 뷰
    public let rateTableView = UITableView().then {
        $0.rowHeight = 60
    }
    
    // 검색 창
    public let searchBar = UISearchBar().then {
        $0.placeholder = "통화 검색"
        $0.searchBarStyle = .minimal
    }
    
    // 검색 결과 없음 라벨
    public let emptyLabel = UILabel().then{
        $0.text = "검색 결과가 없음"
        $0.textAlignment = .center
        $0.textColor = .customSecondaryTextColor
        $0.isHidden = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureSubView()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureSubView(){
        [rateTableView, searchBar, emptyLabel]
            .forEach{ addSubview($0) }
    }
    
    private func configureLayout(){
        
        // 검색바
        searchBar.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalTo(safeAreaLayoutGuide)
        }
        
        // 테이블 뷰
        rateTableView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom)
            $0.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide)
        }
        
        // 검색 결과 없음
        emptyLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
