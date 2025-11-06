//
//  StoolService.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 29/09/25.
//

import Foundation
import CoreData

protocol StoolServiceProtocol {
    func addStoolRecord(period: PeriodEnum, date: Date, format: StoolTypesEnum?, notes: String, color: StoolColorsEnum?, author: String, in careRecipient: CareRecipient)
    
    func deleteStoolRecord(stoolRecord: StoolRecord, from careRecipient: CareRecipient)
    
    func fetchStools(for careRecipient: CareRecipient) -> [StoolRecord]
}

class StoolService: StoolServiceProtocol {
    func addStoolRecord(period: PeriodEnum, date: Date, format: StoolTypesEnum?, notes: String, color: StoolColorsEnum?, author: String, in careRecipient: CareRecipient) {
        
        guard let context = careRecipient.managedObjectContext else { return }
        let newStoolRecord = StoolRecord(context: context)
        
        newStoolRecord.colorType = color
        newStoolRecord.date = date
        newStoolRecord.formatType = format
        newStoolRecord.notes = notes
        newStoolRecord.period = period.rawValue
        newStoolRecord.author = author
        
        if let basicNeeds = careRecipient.basicNeeds {
            let mutableStool = basicNeeds.mutableSetValue(forKey: "stool")
            mutableStool.add(newStoolRecord)
        }
    }
    
    func deleteStoolRecord(stoolRecord: StoolRecord, from careRecipient: CareRecipient) {
        if let basicNeeds = careRecipient.basicNeeds {
            let mutableStool = basicNeeds.mutableSetValue(forKey: "stool")
            mutableStool.remove(stoolRecord)
        }
    }
    
    func fetchStools(for careRecipient: CareRecipient) -> [StoolRecord] {
        guard let context = careRecipient.managedObjectContext else { return [] }
            let request: NSFetchRequest<StoolRecord> = StoolRecord.fetchRequest()
            request.predicate = NSPredicate(format: "basicNeeds.careRecipient == %@", careRecipient)
            request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]

            do {
                return try context.fetch(request)
            } catch {
                print("Error fetching stool records: \(error.localizedDescription)")
                return []
            }
        }
    
}
