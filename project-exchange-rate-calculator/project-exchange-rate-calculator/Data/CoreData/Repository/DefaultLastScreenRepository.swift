//
//  DefaultLastScreenRepository.swift
//  project-exchange-rate-calculator
//
//  Created by 유영웅 on 4/21/25.
//

import Foundation
import CoreData

typealias LastScreenRepositorys = LastScreenPersistentRepository & BaseCoreDataRepository

// MARK: 스크린 케이스 저장 및 불러오기
final class DefaultLastScreenRepository: LastScreenRepositorys {
    
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext = CoreDataStack.shared.context) {
        self.context = context
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
