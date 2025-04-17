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
    
    //특정 행위가 완수되면 해당 context 저장
    private func saveContext(_ message: String, completion:(() throws -> Void)? = nil) {
        guard context.hasChanges else { return }
        do {
            try completion?()
            try context.save()
        } catch {
            print("\(message) 실패: \(error.localizedDescription)")
        }
    }
    
    // 모든 정보 불러오기
    func fetchAll<T: NSManagedObject>(type: T.Type) -> Single<[T]>{
        
        let request = NSFetchRequest<T>(entityName: "\(T.self)")
        
        return Single.create { single in
            do{
                let result = try self.context.fetch(request)
                single(.success(result))
                return Disposables.create()
            }catch{
                print("아이템 리스트 가져오기 실패: \(error.localizedDescription)")
                single(.failure(error))
                return Disposables.create()
            }
        }
    }
    
    // 모든 정보 불러오기
    func fetch<T: NSManagedObject>(type: T.Type, predicate: NSPredicate) -> Single<T>{
        
        let request = NSFetchRequest<T>(entityName: "\(T.self)")
        request.predicate = predicate
        
        return Single.create { [weak self] single in
            do{
                guard let object = try self?.context.fetch(request).first else { return Disposables.create() }
                single(.success(object))
                return Disposables.create()
            }catch{
                print("아이템 가져오기 실패: \(error.localizedDescription)")
                single(.failure(error))
                return Disposables.create()
            }
        }
    }
    
    // 객체 업데이트
    func update<T: NSManagedObject>(type: T.Type, predicate: NSPredicate, updates: [String: Any]) {
        
        let request = NSFetchRequest<T>(entityName: "\(T.self)")
        request.predicate = predicate

        saveContext("업데이트"){
            guard let object = try self.context.fetch(request).first else { return }
            updates.forEach { object.setValue($1, forKey: $0) }
        }
    }
}
