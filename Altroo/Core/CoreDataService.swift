//
//  CoreDataService.swift
//  Altroo
//
//  Created by Raissa Parente on 23/09/25.
//

final class CoreDataService {
    private let stack: CoreDataStack
    
    init(stack: CoreDataStack = .shared) {
        self.stack = stack
    }
    
    func saveContext() {
        let context = stack.context
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Failed saving context: \(error)")
            }
        }
    }
    
    func fetchCareRecipient() -> [CareRecipient] {
        let request: NSFetchRequest<Destination> =  CareRecipient.fetchRequest()
        do {
            return try stack.context.fetch(request)
        } catch {
            print("Fetch error: \(error)")
            return []
        }
    }
    
    func delete(_ destination: Destination) {
        stack.context.delete(destination)
        saveContext()
    }
}
