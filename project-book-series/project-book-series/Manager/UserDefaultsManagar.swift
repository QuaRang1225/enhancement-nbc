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
        case episode
    }
    //MARK: 싱글턴 인스턴스 생성
    static let shared = UserDefaultsManagar()
    
    func getData<T>(mode: Mode) -> T {
        guard let object = UserDefaults.standard.object(forKey: mode.rawValue) as? T else{
            switch mode {
            case .expand: return (false as! T)
            case .episode: return (0 as! T)
            }
        }
        return object
    }
    func setData<T:Codable>(mode:Mode,value:T){
        UserDefaults.standard.set(value, forKey: mode.rawValue)
    }
}
