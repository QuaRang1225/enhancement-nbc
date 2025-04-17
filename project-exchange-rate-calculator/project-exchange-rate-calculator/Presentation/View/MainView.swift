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

final class MainView:UIView{
    
    public let rateTableView = UITableView().then {
        $0.rowHeight = 60
    }
    
    public let searchBar = UISearchBar().then {
        $0.placeholder = "통화 검색"
        $0.searchBarStyle = .minimal
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
        [rateTableView, searchBar]
            .forEach{ addSubview($0) }
    }
    
    private func configureLayout(){
        searchBar.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalTo(safeAreaLayoutGuide)
        }
        rateTableView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom)
            $0.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
}
