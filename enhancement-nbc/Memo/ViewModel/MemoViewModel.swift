//
//  MemoViewModel.swift
//  enhancement-nbc
//
//  Created by 유영웅 on 2/19/25.
//

import Foundation

class MemoViewModel {
    var memoList: [Memo] = []
    private let defaults = UserDefaults.standard
    
    var onUpdate: (() -> Void)?
    
    init() {
        loadMemoList()
    }
    //데이터 불러오기
    func loadMemoList() {
        guard let data = defaults.object(forKey: "memo") as? Data,
              let loadedMemo = try? JSONDecoder().decode([Memo].self, from: data) else { return }
        memoList = loadedMemo
        onUpdate?()
    }
    //데이터 저장
    func saveMemo(_ memo:Memo){
        memoList.append(memo)
        updateDefaults()
        onUpdate?()
    }
    //데이터 삭제
    func deleteMemo(_ indexPath:IndexPath){
        memoList.remove(at: indexPath.row)
        updateDefaults()
        onUpdate?()
    }
    //데이터 상태 업데이트
    private func updateDefaults(){
        let encoder = JSONEncoder()
        guard let encoded = try? encoder.encode(memoList) else { return }
        defaults.set(encoded, forKey: "memo")
    }
    
}
