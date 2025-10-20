//
//  FeedingService.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 29/09/25.
//

import Foundation

protocol FeedingServiceProtocol {
    func addFeedingRecord(amountEaten: MealAmountEatenEnum, Date: Date, period: PeriodEnum, notes: String, photo: Data?, mealCategory: MealCategoryEnum, in careRecipient: CareRecipient)
    
    func deleteFeedingRecord(feedingRecord: FeedingRecord, from careRecipient: CareRecipient)
}

class FeedingService: FeedingServiceProtocol {
    func addFeedingRecord(amountEaten: MealAmountEatenEnum, Date: Date, period: PeriodEnum, notes: String, photo: Data?, mealCategory: MealCategoryEnum, in careRecipient: CareRecipient) {
        
        guard let context = careRecipient.managedObjectContext else { return }
        let newFeedingRecord = FeedingRecord(context: context)
        
        newFeedingRecord.notes = notes
        newFeedingRecord.amountEaten = amountEaten.displayText
        newFeedingRecord.date = Date
        newFeedingRecord.period = period.rawValue
        newFeedingRecord.photo = photo
        newFeedingRecord.mealCategory = mealCategory.displayText
        
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
    
}
