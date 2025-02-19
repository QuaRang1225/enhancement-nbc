//
//  MemoView.swift
//  enhancement-nbc
//
//  Created by 유영웅 on 2/19/25.
//

import Foundation
import UIKit
import SwiftUI

class MemoView:UIView{
    
    let headerView = HeaderView()
    let tableView = UITableView(frame: .zero,style: .insetGrouped)
    
    func configureView(){
        addSubview(tableView)
        addSubview(headerView)
        configureHeaderView()
    }
    func configureHeaderView(){
        headerView.title.text = "Memo"
        headerView.rightItem.setImage(UIImage(systemName: "plus"), for: .normal)
        headerView.leftItem.setImage(UIImage(systemName: "exclamationmark.circle.fill"), for: .normal)
        headerView.leftItem.tintColor = .red
    }
    func configureLayout(){
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: leftAnchor),
            tableView.rightAnchor.constraint(equalTo: rightAnchor),
            
            headerView.topAnchor.constraint(equalTo: topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 100),
            headerView.leftAnchor.constraint(equalTo: leftAnchor),
            headerView.rightAnchor.constraint(equalTo: rightAnchor)
        ])
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

#Preview {
    UIViewPreview(MemoView()).ignoresSafeArea()
}

