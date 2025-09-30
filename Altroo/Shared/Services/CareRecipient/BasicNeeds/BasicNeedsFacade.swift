//
//  BasicNeedsFacade.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 29/09/25.
//

import Foundation

class BasicNeedsFacade {
    private let persistenceService: CoreDataService
    
    private let feedingService: FeedingServiceProtocol
    private let hydrationService: HydrationServiceProtocol
    private let stoolService: StoolServiceProtocol
    private let urineService: UrineServiceProtocol
    
    init(feedingService: FeedingService, hydrationService: HydrationService, stoolService: StoolService, urineService: UrineService, persistenceService: CoreDataService) {
        self.feedingService = feedingService
        self.hydrationService = hydrationService
        self.stoolService = stoolService
        self.urineService = urineService
        self.persistenceService = persistenceService
    }
    
    // MARK: - FEEDING ACTIONS
    func addFeeding(behavior: String, date: Date, period: PeriodEnum, feedingRecordDescription: String, photo: Data, in careRecipient: CareRecipient) {
        feedingService.addFeedingRecord(behavior: behavior, Date: date, period: period, feedingRecordDescription: feedingRecordDescription, photo: photo, in: careRecipient)
        
        persistenceService.saveContext()
    }
    
    func deleteFeeding(feedingRecord: FeedingRecord, from careRecipient: CareRecipient) {
        feedingService.deleteFeedingRecord(feedingRecord: feedingRecord, from: careRecipient)
        
        persistenceService.saveContext()
    }
    
    // MARK: - HYDRATION ACTIONS
    func addHydration(period: PeriodEnum, date: Date, behavior: String, waterQuantity: Double, in careRecipient: CareRecipient) {
        hydrationService.addHydrationRecord(period: period, date: date, behavior: behavior, waterQuantity: waterQuantity, in: careRecipient)
        
        persistenceService.saveContext()
    }
    
    func deleteHydration(hydrationRecord: HydrationRecord, from careRecipient: CareRecipient) {
        hydrationService.deleteHydrationRecord(hydrationRecord: hydrationRecord, from: careRecipient)
        
        persistenceService.saveContext()
    }
    
    // MARK: - STOOL ACTIONS
    func addStool(period: PeriodEnum, date: Date, format: String, hadPain: Bool, color: String, in careRecipient: CareRecipient) {
        stoolService.addStoolRecord(period: period, date: date, format: format, hadPain: hadPain, color: color, in: careRecipient)
        
        persistenceService.saveContext()
    }

    func deleteStool(stoolRecord: StoolRecord, from careRecipient: CareRecipient) {
        stoolService.deleteStoolRecord(stoolRecord: stoolRecord, from: careRecipient)
        
        persistenceService.saveContext()
    }
    
    // MARK: - URINE ACTIONS
    func addUrine(period: PeriodEnum, date: Date, color: String, in careRecipient: CareRecipient, hadPain: Bool) {
        urineService.addUrineRecord(period: period, date: date, hadPain: hadPain, color: color, in: careRecipient)
        
        persistenceService.saveContext()
    }

    func deleteUrine(urineRecord: UrineRecord, from careRecipient: CareRecipient) {
        urineService.deleteUrineRecord(urineRecord: urineRecord, from: careRecipient)
        
        persistenceService.saveContext()
    }
    
}
