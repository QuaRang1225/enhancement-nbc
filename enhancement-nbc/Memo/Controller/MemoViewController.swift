//
//  MemoViewController.swift
//  enhancement-nbc
//
//  Created by 유영웅 on 2/18/25.
//

import UIKit

final class MemoViewController: UIViewController {

    var vm = MemoViewModel()
    let memoView = MemoView()
    let defaults = UserDefaults.standard
    
    
    override func loadView() {
        view = memoView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureActions()
        bindViewModel()
    }
    //테이블뷰 사용설정
    private func configureTableView(){
        memoView.tableView.dataSource = self
        memoView.tableView.delegate = self
        memoView.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "MemoCell")
    }
    //버튼 타겟설정
    private func configureActions(){
        memoView.headerView.rightItem.addTarget(self, action: #selector(addMemo), for: .touchUpInside)
        memoView.headerView.leftItem.addTarget(self, action: #selector(reportError), for: .touchUpInside)
    }
    //특정 이벤트(추가/삭제/로드) 후 테이블뷰 reload
    private func bindViewModel() {
        vm.onUpdate = { [weak self] in
            self?.memoView.tableView.reloadData()
        }
    }
    //헤더 아이템 버튼 이벤트들
    @objc private func reportError(){
        fatalError("crash!!!!!!!!!!!!!!")
    }
    @objc private func addMemo(){
        present(createAddMemoAlert(), animated: true)
    }
    
    //메모 작성 시 알림 추가
    private func createAddMemoAlert()->UIAlertController{
        let alert = UIAlertController(title: "Add memo", message: nil, preferredStyle: .alert)
        alert.addTextField { $0.placeholder = "Please write down a memo." }
        
        let addAction = UIAlertAction(title: "Add", style: .default){ _ in
            guard let text = alert.textFields?.first?.text else { return }
            if text.isEmpty{
                self.present(self.createEmptyMemoAlert(alert), animated: true)
            }else{
                self.vm.saveMemo(Memo(content: text))
            }
        }
        let canelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(addAction)
        alert.addAction(canelAction)
        return alert
    }
    //메모가 비었을 때 알림 추가
    private func createEmptyMemoAlert(_ alert:UIAlertController)->UIAlertController{
        let emptyAlert = UIAlertController(title: "Empty Memo", message: "You cannot add an empty memo.", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "confirm", style: .default){ _ in
            self.present(alert, animated: true)
        }
        emptyAlert.addAction(confirmAction)
        return emptyAlert
        
    }
}

#Preview{
    MemoViewController()
}


extension MemoViewController:UITableViewDelegate,UITableViewDataSource{
    //테이블 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        vm.memoList.count
    }
    //셀 설정
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemoCell", for: indexPath)
        cell.textLabel?.text = vm.memoList[indexPath.row].content
        return cell
    }
    //삭제 이벤트
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{ self.vm.deleteMemo(indexPath) }
    }
}



