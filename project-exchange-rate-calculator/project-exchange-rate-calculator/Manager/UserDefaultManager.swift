//
//  UserDefaultManager.swift
//  project-exchange-rate-calculator
//
//  Created by 유영웅 on 4/19/25.
//

import Foundation

// MARK: UserDefautes 매니저
final class UserDefaultManager {
    
    enum Key: String {
        case date = "lastUpdateTime"
    }
    static let shared = UserDefaultManager()
    
    
    // 데이터 로딩
    func changedDate(key: Key, newDate: Date) -> Date? {
        guard let oldDate = UserDefaults.standard.object(forKey: key.rawValue) as? Date else {
            UserDefaults.standard.set(newDate, forKey: key.rawValue)
            return nil
        }
        let calendar = Calendar.current
        return !calendar.isDate(oldDate, inSameDayAs: newDate) ? oldDate : nil
    }
}
