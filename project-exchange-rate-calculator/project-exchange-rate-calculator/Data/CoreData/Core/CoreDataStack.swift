//
//  CoreDataStack.swift
//  project-exchange-rate-calculator
//
//  Created by 유영웅 on 4/21/25.
//

import Foundation
import CoreData

// MARK: NSPersistentContainer 설정과 viewContext, backgroundContext 제공
final class CoreDataStack {
    static let shared = CoreDataStack()

    private init() { }

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
}
