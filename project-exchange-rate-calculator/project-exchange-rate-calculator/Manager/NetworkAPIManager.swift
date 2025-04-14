//
//  NetWorkAPIManager.swift
//  project-exchange-rate-calculator
//
//  Created by 유영웅 on 4/14/25.
//

import Foundation
import RxSwift

//MARK: NetworkAPIManager - API CRUD
class NetworkAPIManager{
    
    //환율 정보 fetch
    static func fetchRates() -> Single<ExchangeRatesResponse> {
        return Single<ExchangeRatesResponse>.create { single in
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
                single(.success(result.rates))
            }
            
            task.resume()
            return Disposables.create { task.cancel() }
        }
    }
}
