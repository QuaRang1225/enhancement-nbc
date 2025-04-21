//
//  BaseRepository.swift
//  project-exchange-rate-calculator
//
//  Created by 유영웅 on 4/21/25.
//

import Foundation
import CoreData

// MARK: Data Layer의 기본 Repository
class BaseCoreDataRepository {
    
    // context를 받아 저장하는 비동기 함수
    func saveContext(_ context: NSManagedObjectContext, _ message: String) async throws {
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
}
