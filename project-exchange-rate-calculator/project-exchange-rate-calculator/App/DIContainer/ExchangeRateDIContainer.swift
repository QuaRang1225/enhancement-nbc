//
//  DIContainer.swift
//  project-exchange-rate-calculator
//
//  Created by 유영웅 on 4/21/25.
//

import Foundation

final class ExchangeRateDIContainer {
    
    // MARK: - Repository
    private var makeAPIExchangeRateRepository: ExchangeRateAPIRepository {
        DefaultAPIExchangeRateRepository()
    }

    private var makeLocalExchangeRateRepository: ExchangeRatePersistentRepository {
        DefaultExchangeRateRepository()
    }
    
    private var makeLastScreenRepository: LastScreenPersistentRepository {
        DefaultLastScreenRepository()
    }
    
    // MARK: - UseCase
    private var makeAPIExchangeRateUseCase: FetchAPIExchangeRateUseCase {
        DefaultFetchAPIExchangeRateUseCase(repository: makeAPIExchangeRateRepository)
    }

    private var makeLocalExchangeRateUseCase: ExchangeRatePersistentUseCase {
        DefaultExchangeRatePersistentUseCase(repository: makeLocalExchangeRateRepository)
    }

    var makeLastScreenUseCase: LastScreenPersistentUseCase {
        DefaultLastScreenPersistentUseCase(repository: makeLastScreenRepository)
    }

    // MARK: - ViewModel
    var makeMainViewModel: MainViewModel {
        MainViewModel(
            apiUseCase: makeAPIExchangeRateUseCase,
            localUseCase: makeLocalExchangeRateUseCase,
            lastScreenUseCase: makeLastScreenUseCase
        )
    }

    var makeCalculateViewModel: CalculatorViewModel {
        CalculatorViewModel(localUseCase: makeLocalExchangeRateUseCase)
    }
}
