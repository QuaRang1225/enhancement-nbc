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
    static func fetchRates() -> Single<[ExchangeRateModel]> {
        return Single<[ExchangeRateModel]>.create { single in
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
                single(.success(result.toEntity()))
            }
            
            task.resume()
            return Disposables.create { task.cancel() }
        }
    }
}


