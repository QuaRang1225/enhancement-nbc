//
//  NetWorkAPIManager.swift
//  project-exchange-rate-calculator
//
//  Created by 유영웅 on 4/14/25.
//

import Foundation

//MARK: NetworkAPIManager - API CRUD
class NetworkAPIManager{
    
    //환율 정보 fetch
    static func fetchRates() async throws -> Result<ExchangeRatesResponse, DataError> {
        guard let url = URL(string: "https://open.er-api.com/v6/latest/USD") else {
            throw DataError.requestFailed
        }
        
        do{
            let data = try await URLSession.shared.data(from: url).0
            let response = try JSONDecoder().decode(Exchange.self, from: data)
            return .success(response.rates)
        }catch {
            throw DataError.decodigError
        }
    }
    
}
