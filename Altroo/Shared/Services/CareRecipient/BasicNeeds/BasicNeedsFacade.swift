//
//  BasicNeedsFacade.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 29/09/25.
//
import Foundation
import CoreData

final class BasicNeedsFacade: BasicNeedsFacadeProtocol {
    // MARK: Services
    private let persistenceService: CoreDataService
    private let feedingService: FeedingServiceProtocol
    private let hydrationService: HydrationServiceProtocol
    private let stoolService: StoolServiceProtocol
    private let urineService: UrineServiceProtocol
    
    init(
        feedingService: FeedingServiceProtocol,
        hydrationService: HydrationServiceProtocol,
        stoolService: StoolServiceProtocol,
        urineService: UrineServiceProtocol,
        persistenceService: CoreDataService
    ) {
        self.feedingService = feedingService
        self.hydrationService = hydrationService
        self.stoolService = stoolService
        self.urineService = urineService
        self.persistenceService = persistenceService
    }
    
    // MARK: - FEEDING ACTIONS
    
    func addFeeding(amountEaten: MealAmountEatenEnum, date: Date, period: PeriodEnum, notes: String, mealCategory: MealCategoryEnum, author: String, in careRecipient: CareRecipient) {
        feedingService.addFeedingRecord(amountEaten: amountEaten, Date: date, period: period, notes: notes, photo: nil, mealCategory: mealCategory, author: author, in: careRecipient)
        
        persistenceService.save()
    }
    
    func deleteFeeding(feedingRecord: FeedingRecord, from careRecipient: CareRecipient) {
        feedingService.deleteFeedingRecord(feedingRecord: feedingRecord, from: careRecipient)
        persistenceService.save()
    }
    
    func fetchFeedings(for careRecipient: CareRecipient) -> [FeedingRecord] {
        return feedingService.fetchFeedings(for: careRecipient)
    }
    
    // MARK: - HYDRATION ACTIONS
    func addHydration(period: PeriodEnum, date: Date, waterQuantity: Double, author: String, in careRecipient: CareRecipient) {
        hydrationService.addHydrationRecord(period: period, date: date, waterQuantity: waterQuantity, author: author, in: careRecipient)
        persistenceService.save()
    }
    
    func deleteHydration(hydrationRecord: HydrationRecord, from careRecipient: CareRecipient) {
        hydrationService.deleteHydrationRecord(hydrationRecord: hydrationRecord, from: careRecipient)
        persistenceService.save()
    }
    
    func fetchHydrations(for careRecipient: CareRecipient) -> [HydrationRecord] {
        hydrationService.fetchHydrations(for: careRecipient)
    }

    
    // MARK: - STOOL ACTIONS
    func addStool(period: PeriodEnum, date: Date, format: StoolTypesEnum?, notes: String, color: StoolColorsEnum?, author: String, in careRecipient: CareRecipient) {
        stoolService.addStoolRecord(period: period, date: date, format: format, notes: notes, color: color, author: author, in: careRecipient)
        persistenceService.save()
    }

    func deleteStool(stoolRecord: StoolRecord, from careRecipient: CareRecipient) {
        stoolService.deleteStoolRecord(stoolRecord: stoolRecord, from: careRecipient)
        persistenceService.save()
    }
    
    func fetchStools(for careRecipient: CareRecipient) -> [StoolRecord] {
        stoolService.fetchStools(for: careRecipient)
    }

    
    // MARK: - URINE ACTIONS
    func addUrine(
        period: PeriodEnum,
        date: Date,
        color: UrineColorsEnum?,
        in careRecipient: CareRecipient,
        author: String,
        observation: String?
    ) {
        urineService.addUrineRecord(
            period: period,
            date: date,
            color: color,
            observation: observation, author: author,
            to: careRecipient
        )
        persistenceService.save()
    }

    func updateUrine(
        _ record: UrineRecord,
        period: PeriodEnum? = nil,
        date: Date? = nil,
        color: UrineColorsEnum? = nil,
        observation: String? = nil
    ) {
        urineService.updateUrineRecord(
            record,
            period: period,
            date: date,
            color: color,
            observation: observation
        )
        persistenceService.save()
    }

    func urineRecord(with id: UUID, for careRecipient: CareRecipient) -> UrineRecord? {
        urineService.urineRecord(with: id, for: careRecipient)
    }

    func deleteUrine(urineRecord: UrineRecord, from careRecipient: CareRecipient) {
        urineService.deleteUrineRecord(urineRecord, from: careRecipient)
        persistenceService.save()
    }
    
    func fetchUrines(for careRecipient: CareRecipient) -> [UrineRecord] {
        urineService.fetchUrines(for: careRecipient)
    }
}
