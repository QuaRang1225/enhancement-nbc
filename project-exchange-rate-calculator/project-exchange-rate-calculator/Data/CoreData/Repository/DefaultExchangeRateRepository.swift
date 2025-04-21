//
//  DefaultExchangeRateRepository.swift
//  project-exchange-rate-calculator
//
//  Created by 유영웅 on 4/21/25.
//

import Foundation
import RxSwift
import CoreData

typealias ExchangeRateRepositorys = ExchangeRatePersistentRepository & BaseCoreDataRepository

// MARK: 환율 데이터 저장 및 불러오기
final class DefaultExchangeRateRepository: ExchangeRateRepositorys {

    let context: NSManagedObjectContext
    let mapper: ExchageRateMapper
    
    init(context: NSManagedObjectContext = CoreDataStack.shared.context) {
        self.context = context
        self.mapper = ExchageRateMapper(context: context)
    }
    
    // 모든 객체 저장
    func saveAll(models: [ExchangeRateModel]) async throws {
        mapper.toEntitys(models: models).forEach { context.insert($0) }
        try await saveContext(context, "모든 객체 저장")
    }
    
    // fetchAll을 Single로 반환하기
    func fetchAll() -> Single<[ExchangeRateModel]> {
        return Single.create { [weak self] single in
            guard let self else { return Disposables.create() }
            let request = NSFetchRequest<ExchangeRate>(entityName: "\(ExchangeRate.self)")
            
            do {
                let result = try self.context.fetch(request)
                print("Coredata 요청 성공")
                single(.success(mapper.toModels(entitys: result)))
            } catch {
                single(.failure(DataError.requestFailed))
            }
            return Disposables.create()
        }
    }
    
    // fetch를 Single로 반환하기
    func fetch(id: UUID) -> Single<ExchangeRateModel?> {
        return Single.create { [weak self] single in
            
            guard let self else { return Disposables.create() }
            let request = NSFetchRequest<ExchangeRate>(entityName: "\(ExchangeRate.self)")
            request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            
            do {
                let result = try self.context.fetch(request).first
                single(.success(mapper.toModel(entity: result)))
            } catch {
                single(.failure(DataError.requestFailed))
            }
            return Disposables.create()
        }
    }
    
    // 객체 업데이트
    func update(model: ExchangeRateModel) async throws {
        
        let request = NSFetchRequest<ExchangeRate>(entityName: "\(ExchangeRate.self)")
        request.predicate = NSPredicate(format: "id == %@", model.id as CVarArg)
        request.fetchLimit = 1
        
        guard let object = try context.fetch(request).first else { return }
        
        object.currency = model.currency
        object.country = model.country
        object.rate = model.rate
        object.isBookmark = model.isBookmark
        object.rateOfChange = model.rateOfChange
        
        try await saveContext(context, "업데이트")
    }
    
    
}
