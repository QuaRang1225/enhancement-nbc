//
//  MemoViewController.swift
//  enhancement-nbc
//
//  Created by 유영웅 on 2/18/25.
//

import UIKit

class MemoViewController: UIViewController {

    var list:[String] = []
    let defaults = UserDefaults.standard
    //header
    let addButton:UIButton={
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    let titleLabel:UILabel={
        let label = UILabel()
        label.text = "Memo"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.addSubview(addButton)
        view.addSubview(titleLabel)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupLayout()
        actions()
        guard let list = defaults.array(forKey: "memo") as? [String] else {return}
        self.list = list
        
    }
    
    lazy var tableView:UITableView = {
        let table = UITableView(frame: .zero,style: .insetGrouped)
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    func setupView(){
        view.addSubview(tableView)
        view.addSubview(headerView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "MemoCell")
    }
    func setupLayout(){
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 100),
            headerView.widthAnchor.constraint(equalToConstant: view.bounds.width)
        ])
        //header
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: headerView.bottomAnchor,constant: -20),
            
            addButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
            addButton.centerYAnchor.constraint(equalTo: headerView.bottomAnchor,constant: -20),
        ])
    }
    func actions(){
        addButton.addTarget(self, action: #selector(addMemo), for: .touchUpInside)
    }
    @objc func errors(){
        fatalError("강제 크래시 발생!")
    }
    @objc func addMemo(){
        let alert = UIAlertController(title: "Add memo", message: nil, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Please write down a memo."
        }
        let addAction = UIAlertAction(title: "Add", style: .default){ _ in
            guard let text = alert.textFields?.first?.text else { return }
            self.list.append(text)
            let newIndexPath = IndexPath(row: self.list.count - 1, section: 0)
            self.tableView.insertRows(at: [newIndexPath], with: .automatic)
            self.defaults.set(self.list, forKey: "memo")
        }
        let canelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(addAction)
        alert.addAction(canelAction)
        
        present(alert, animated: true, completion: nil)
    }
}

#Preview{
    MemoViewController()
}


extension MemoViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemoCell", for: indexPath) // 셀 재사용
        cell.textLabel?.text = list[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            list.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            defaults.set(list, forKey: "memo")
        }
    }
}
