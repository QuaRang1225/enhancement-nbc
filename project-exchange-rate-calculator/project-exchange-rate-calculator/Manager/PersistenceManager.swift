//
//  CoreDataStack.swift
//  project-exchange-rate-calculator
//
//  Created by 유영웅 on 4/17/25.
//

import Foundation
import CoreData
import RxSwift

// 타입명 재정의
typealias Entitys = [[String: Any]]
typealias Entity = [String: Any]

// MARK: NSPersistentContainer 설정과 viewContext, backgroundContext 제공
final class PersistenceManager {
    
    static let shared = PersistenceManager()
    
    // Core Data의 전체 스택을 관리하는 컨테이너
    lazy var persistentContainer: NSPersistentContainer = {
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
    
    // 모든 객체 저장
    func saveAll<T: NSManagedObject>(type: T.Type, values: Entitys) async throws {
        for value in values {
            guard let entity = NSEntityDescription.entity(forEntityName: "\(T.self)", in: context) else { continue }
            let object = T(entity: entity, insertInto: context)
            value.forEach { key, val in
                object.setValue(val, forKey: key)
            }
        }
        try await saveContext(context, "모든 객체 저장")
    }
    
    // fetchAll을 Single로 반환하기
    func fetchAll<T: NSManagedObject>(type: T.Type) -> Single<[T]> {
        return Single.create { [weak self] single in
            
            guard let self else { return Disposables.create() }
            let request = NSFetchRequest<T>(entityName: "\(T.self)")
            
            do {
                let result = try self.context.fetch(request)
                single(.success(result))
            } catch {
                single(.failure(DataError.requestFailed))
            }
            return Disposables.create()
        }
    }

    // fetch를 Single로 반환하기
    func fetch<T: NSManagedObject>(type: T.Type, id: UUID) -> Single<T?> {
        return Single.create { [weak self] single in
            
            guard let self else { return Disposables.create() }
            let request = NSFetchRequest<T>(entityName: "\(T.self)")
            request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            
            do {
                let result = try self.context.fetch(request).first
                single(.success(result))
            } catch {
                single(.failure(DataError.requestFailed))
            }
            return Disposables.create()
        }
    }
    
    // 객체 업데이트
    func update<T: NSManagedObject>(type: T.Type, entity: Entity) async throws{
        guard let id = entity["id"] as? UUID else { return }
        
        let request = NSFetchRequest<T>(entityName: "\(T.self)")
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        request.fetchLimit = 1

        guard let object = try context.fetch(request).first else { return }
        
        entity.forEach { key, value in
            guard key != "id" else { return }
            let oldValue = object.value(forKey: key)
            if !(oldValue as AnyObject).isEqual(value) {
                object.setValue(value, forKey: key)
            }
        }
        try await saveContext(context, "업데이트")
    }
}
