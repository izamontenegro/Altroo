//
//  FeedingService.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 29/09/25.
//

import Foundation

protocol FeedingServiceProtocol {
    func addFeedingRecord(behavior: String, Date: Date, period: PeriodEnum, feedingRecordDescription: String, photo: Data, in careRecipient: CareRecipient)
    
    func deleteFeedingRecord(feedingRecord: FeedingRecord, from careRecipient: CareRecipient)
}

class FeedingService: FeedingServiceProtocol {
    func addFeedingRecord(behavior: String, Date: Date, period: PeriodEnum, feedingRecordDescription: String, photo: Data, in careRecipient: CareRecipient) {
        
        guard let context = careRecipient.managedObjectContext else { return }
        let newFeedingRecord = FeedingRecord(context: context)
        
        newFeedingRecord.feedingRecordDescription = feedingRecordDescription
        newFeedingRecord.behavior = behavior
        newFeedingRecord.date = Date
        newFeedingRecord.period = period.rawValue
        newFeedingRecord.photo = photo
        
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
