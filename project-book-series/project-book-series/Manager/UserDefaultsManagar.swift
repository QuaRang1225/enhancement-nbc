//
//  UserDefaultsManagar.swift
//  project-book-series
//
//  Created by 유영웅 on 3/28/25.
//

import Foundation

//MARK: 데이터를 영구적으로 저장하기 위한 매니저
final class UserDefaultsManagar{
    enum Mode:String{
        case expand
        case summary
    }
    //MARK: 싱글턴 인스턴스 생성
    static let shared = UserDefaultsManagar()
    
    func getData<T>(mode: Mode) -> T? {
        guard let object = UserDefaults.standard.object(forKey: mode.rawValue) as? T else{
            switch mode {
            case .expand:
                return (false as! T)
            case .summary:
                return SummaryAttributes() as? T
            }
        }
        
        return object
    }
    func setData<T:Codable>(mode:Mode,value:T){
        guard let value = try? JSONEncoder().encode(value),let value = value as? T else { return }
        UserDefaults.standard.set(value, forKey: mode.rawValue)
        print(type(of: UserDefaults.standard.object(forKey: mode.rawValue)))
    }
    func removeData(mode: Mode){
        UserDefaults.standard.removeObject(forKey: mode.rawValue)
    }
}
