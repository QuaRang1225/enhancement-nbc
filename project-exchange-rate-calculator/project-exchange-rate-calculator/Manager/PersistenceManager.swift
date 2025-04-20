//
//  CoreDataStack.swift
//  project-exchange-rate-calculator
//
//  Created by 유영웅 on 4/17/25.
//

import Foundation
import CoreData
import RxSwift


// MARK: NSPersistentContainer 설정과 viewContext, backgroundContext 제공
final class PersistenceManager {
    
    static let shared = PersistenceManager()
    
    // Core Data의 전체 스택을 관리하는 컨테이너
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("컨테이너 로딩 실패: \(error)")
            }
        }
        return container
    }()
    
    // Core Data의 작업 공간(CRUD)
    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    // context를 받아 저장하는 비동기 함수
    private func saveContext(_ context: NSManagedObjectContext, _ message: String) async throws {
        guard context.hasChanges else { return }
        do {
            try await context.perform {
                try context.save()
            }
        } catch {
            print("\(message) 실패: \(error.localizedDescription)")
            throw error
        }
    }
    
    // [Entity] -> [Model]
    private func toEntitys(models: [ExchangeRateModel]) -> [ExchangeRate] {
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
    private func toModels(entitys: [ExchangeRate]) -> [ExchangeRateModel] {
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
    private func toModel(entity: ExchangeRate?) -> ExchangeRateModel? {
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
    private func toEntity(model: ExchangeRateModel) -> ExchangeRate {
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

// MARK: 환율 데이터 저장 및 불러오기
extension PersistenceManager {
    
    // 모든 객체 저장
    func saveAll(entitys: [ExchangeRateModel]) async throws {
        toEntitys(models: entitys).forEach { context.insert($0) }
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
                single(.success(toModels(entitys: result)))
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
                single(.success(toModel(entity: result)))
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

// MARK: 스크린 상태 저장 및 불러오기
extension PersistenceManager {
    
    // 스크린 타입
    enum LastScreenType: String {
        case list
        case calculator
    }
    
    // 스크린 타입에 따라 해당 타입 자체를 저장, 저장한 이력이있다면 삭제 후 저장
    func saveLastScreen(type: LastScreenType, currencyID: UUID? = nil) async throws {

        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "LastScreen")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetch)
        _ = try? context.execute(deleteRequest)

        let entity = NSEntityDescription.entity(forEntityName: "LastScreen", in: context)!
        let object = NSManagedObject(entity: entity, insertInto: context)
        object.setValue(type.rawValue, forKey: "screenType")
        object.setValue(currencyID, forKey: "currencyID")

        try await saveContext(context, "마지막 스크린 저장")
    }
    
    // 한번이라도 저장한 적이 있는 스크린 타입을 반환 없으면 nil을 반환
    func fetchLastScreen() -> (LastScreenType, UUID?)? {
        let request = NSFetchRequest<NSManagedObject>(entityName: "LastScreen")

        if let result = try? context.fetch(request).first,
           let rawType = result.value(forKey: "screenType") as? String,
           let type = LastScreenType(rawValue: rawType) {

            let id = result.value(forKey: "currencyID") as? UUID
            return (type, id)
        }
        return nil
    }
}
