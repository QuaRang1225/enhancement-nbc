//
//  DefaultRemoteExchangeRateRepository.swift
//  project-exchange-rate-calculator
//
//  Created by 유영웅 on 4/21/25.
//

import Foundation
import RxSwift

// MARK: 네트워크 API Repository
final class DefaultAPIExchangeRateRepository: ExchangeRateAPIRepository {
    
    // 환율 정보 fetch
    func fetchRates() -> Single<[ExchangeRateModel]> {
        return Single<[ExchangeRateModel]>.create { single in
            guard let url = NetworkEndpoint.url(.usd) else {
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
                print("네트워크 요청 성공")
                single(.success(result.toModel()))
            }
            
            task.resume()
            return Disposables.create { task.cancel() }
        }
    }
}
