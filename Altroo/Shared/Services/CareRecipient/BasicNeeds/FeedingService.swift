//
//  FeedingService.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 29/09/25.
//

import Foundation
import CoreData

protocol FeedingServiceProtocol {
    func addFeedingRecord(amountEaten: MealAmountEatenEnum, Date: Date, period: PeriodEnum, notes: String, photo: Data?, mealCategory: MealCategoryEnum, author: String, in careRecipient: CareRecipient)
    
    func deleteFeedingRecord(feedingRecord: FeedingRecord, from careRecipient: CareRecipient)
    
    func fetchFeedings(for careRecipient: CareRecipient) -> [FeedingRecord]
}

class FeedingService: FeedingServiceProtocol {
    func addFeedingRecord(amountEaten: MealAmountEatenEnum, Date: Date, period: PeriodEnum, notes: String, photo: Data?, mealCategory: MealCategoryEnum, author: String, in careRecipient: CareRecipient) {
        
        guard let context = careRecipient.managedObjectContext else { return }
        let newFeedingRecord = FeedingRecord(context: context)
        
        newFeedingRecord.notes = notes
        newFeedingRecord.amountEaten = amountEaten.displayText
        newFeedingRecord.date = Date
        newFeedingRecord.period = period.rawValue
        newFeedingRecord.photo = photo
        newFeedingRecord.mealCategory = mealCategory.displayText
        newFeedingRecord.author = author
        
        if let basicNeeds = careRecipient.basicNeeds {
            let mutableFeeding = basicNeeds.mutableSetValue(forKey: "feeding")
            mutableFeeding.add(newFeedingRecord)
        }
    }
    
    func deleteFeedingRecord(feedingRecord: FeedingRecord, from careRecipient: CareRecipient) {
        if let basicNeeds = careRecipient.basicNeeds {
            let mutableFeeding = basicNeeds.mutableSetValue(forKey: "feeding")
            mutableFeeding.remove(feedingRecord)
        }
    }
    
    func fetchFeedings(for careRecipient: CareRecipient) -> [FeedingRecord] {
        guard let context = careRecipient.managedObjectContext else { return []}
        let request: NSFetchRequest<FeedingRecord> = FeedingRecord.fetchRequest()
        request.predicate = NSPredicate(format: "careRecipient == %@", careRecipient)
        request.sortDescriptors = [
            NSSortDescriptor(key: "date", ascending: false)
        ]

        do {
            return try context.fetch(request)
        } catch {
            return []
        }
    }
}
