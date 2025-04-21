//
//  ExchageRateMapper.swift
//  project-exchange-rate-calculator
//
//  Created by 유영웅 on 4/21/25.
//

import Foundation
import CoreData

// MARK: Model to Entity & Entity to Model
struct ExchageRateMapper {
    
    let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext = CoreDataStack.shared.context) {
        self.context = context
    }
    
    // [Entity] -> [Model]
    func toEntitys(models: [ExchangeRateModel]) -> [ExchangeRate] {
        models.map { model in
            let entity = ExchangeRate(context: context)
            entity.currency = model.currency
            entity.country = model.country
            entity.rate = model.rate
            entity.isBookmark = model.isBookmark
            entity.rateOfChange = model.rateOfChange
            entity.id = model.id
            return entity
        }
    }
    
    // [Model] -> [Entity]
    func toModels(entitys: [ExchangeRate]) -> [ExchangeRateModel] {
        entitys.map { entity in
            let entity = ExchangeRateModel(
                id: entity.id!,
                currency: entity.currency ?? "",
                country: entity.country ?? "",
                rate: entity.rate,
                isBookmark: entity.isBookmark,
                rateOfChange: entity.rateOfChange)
            return entity
        }
    }
    
    // Entity -> Model
    func toModel(entity: ExchangeRate?) -> ExchangeRateModel? {
        guard let entity else { return nil }
        return ExchangeRateModel(
            id: entity.id!,
            currency: entity.currency ?? "",
            country: entity.country ?? "",
            rate: entity.rate,
            isBookmark: entity.isBookmark,
            rateOfChange: entity.rateOfChange)
    }
    
    // Model -> Entity
    func toEntity(model: ExchangeRateModel) -> ExchangeRate {
        let entity = ExchangeRate(context: context)
        entity.currency = model.currency
        entity.country = model.country
        entity.rate = model.rate
        entity.isBookmark = model.isBookmark
        entity.rateOfChange = model.rateOfChange
        entity.id = model.id
        return entity
    }
}
