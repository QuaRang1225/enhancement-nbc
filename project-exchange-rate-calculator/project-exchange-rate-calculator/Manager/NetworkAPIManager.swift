//
//  NetWorkAPIManager.swift
//  project-exchange-rate-calculator
//
//  Created by 유영웅 on 4/14/25.
//

import Foundation
import RxSwift
import CoreData

//MARK: NetworkAPIManager - API CRUD
final class NetworkAPIManager {
    
    // 환율 정보 fetch
    static func fetchRates() -> Single<[ExchangeRate]> {
        return Single<[ExchangeRate]>.create { single in
            guard let url = URL(string: "https://open.er-api.com/v6/latest/USD") else {
                single(.failure(DataError.requestFailed))
                return Disposables.create()
            }
            
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let _ = error {
                    single(.failure(DataError.requestFailed))
                    return
                }
                guard let data = data,
                      let result = try? JSONDecoder().decode(Exchange.self, from: data) else {
                    single(.failure(DataError.decodigError))
                    return
                }
                single(.success(transformEntitys(result)))
            }
            
            task.resume()
            return Disposables.create { task.cancel() }
        }
    }
    
    // 네트워크 데이터 DTO Entitys로 변환
    private static func transformEntitys(_ response: Exchange) -> [ExchangeRate] {
        let context = PersistenceManager.shared.context
        
        var rates = [ExchangeRate]()
        
        // ExchangeRate와 ExchangeRateResponse 간 관계 설정
        for (key, value) in response.rates {
            let rate = ExchangeRate(context: context)
            rate.id = UUID()
            rate.currency = key
            rate.country = String.iso_code[key] ?? ""
            rate.rate = value
            rate.isBookmark = false
            
            rates.append(rate)
        }
        UserDefaults.standard.set(response.timeLastUpdateUTC.stringToDate(), forKey: "lastUpdate")
        return rates
    }
}
