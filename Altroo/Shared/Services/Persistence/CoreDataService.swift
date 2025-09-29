//
//  CoreDataService.swift
//  Altroo
//
//  Created by Raissa Parente on 23/09/25.
//

import CoreData
import CloudKit

class CoreDataService: DataRepository {
    
    let stack: CoreDataStack
    
    init(stack: CoreDataStack = .shared) {
        self.stack = stack
    }
    
    func save() {
        let context = stack.context
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Failed saving context: \(error)")
            }
        }
    }
    
    func fetchAllCareRecipients() -> [CareRecipient] {
        let request: NSFetchRequest<CareRecipient> = CareRecipient.fetchRequest()
        do {
            return try stack.context.fetch(request)
        } catch {
            print("Fetch error: \(error)")
            return []
        }
    }
    
    func deleteCareRecipient(_ careRecipient: CareRecipient) {
        stack.context.delete(careRecipient)
        save()
    }
}


