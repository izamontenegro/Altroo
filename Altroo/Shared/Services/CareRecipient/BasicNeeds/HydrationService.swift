//
//  HydrationService.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 29/09/25.
//

import Foundation
import CoreData

protocol HydrationServiceProtocol {
    func addHydrationRecord(period: PeriodEnum, date: Date, waterQuantity: Double, author: String, in careRecipient: CareRecipient)
    
    func deleteHydrationRecord(hydrationRecord: HydrationRecord, from careRecipient: CareRecipient)
    
    func fetchHydrations(for careRecipient: CareRecipient) -> [HydrationRecord]
}

class HydrationService: HydrationServiceProtocol {
    func addHydrationRecord(period: PeriodEnum, date: Date, waterQuantity: Double, author: String, in careRecipient: CareRecipient)  {
        
        guard let context = careRecipient.managedObjectContext else { return }
        let newHydrationRecord = HydrationRecord(context: context)
        
        newHydrationRecord.date = date
        newHydrationRecord.period = period.rawValue
        newHydrationRecord.waterQuantity = waterQuantity
        newHydrationRecord.author = author
        
        if let basicNeeds = careRecipient.basicNeeds {
            let mutableHydration = basicNeeds.mutableSetValue(forKey: "hydration")
            mutableHydration.add(newHydrationRecord)
        }
    }
    
    func deleteHydrationRecord(hydrationRecord: HydrationRecord, from careRecipient: CareRecipient) {
        if let basicNeeds = careRecipient.basicNeeds {
            let mutableHydration = basicNeeds.mutableSetValue(forKey: "hydration")
            mutableHydration.remove(hydrationRecord)
        }
    }
    
    
    func fetchHydrations(for careRecipient: CareRecipient) -> [HydrationRecord] {
        guard let context = careRecipient.managedObjectContext else { return [] }
        let request: NSFetchRequest<HydrationRecord> = HydrationRecord.fetchRequest()
        request.predicate = NSPredicate(format: "basicNeeds.careRecipient == %@", careRecipient)
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]

        do {
            return try context.fetch(request)
        } catch {
            print("Error fetching hydration records: \(error.localizedDescription)")
            return []
        }
    }
}
