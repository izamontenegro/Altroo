//
//  BasicNeedsFacade.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 29/09/25.
//
import Foundation

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
    func addFeeding(behavior: String, date: Date, period: PeriodEnum, feedingRecordDescription: String, photo: Data, in careRecipient: CareRecipient) {
        feedingService.addFeedingRecord(
            behavior: behavior,
            Date: date,
            period: period,
            feedingRecordDescription: feedingRecordDescription,
            photo: photo,
            in: careRecipient
        )
        persistenceService.save()
    }
    
    func deleteFeeding(feedingRecord: FeedingRecord, from careRecipient: CareRecipient) {
        feedingService.deleteFeedingRecord(feedingRecord: feedingRecord, from: careRecipient)
        persistenceService.save()
    }
    
    // MARK: - HYDRATION ACTIONS
    func addHydration(period: PeriodEnum, date: Date, behavior: String, waterQuantity: Double, in careRecipient: CareRecipient) {
        hydrationService.addHydrationRecord(period: period, date: date, behavior: behavior, waterQuantity: waterQuantity, in: careRecipient)
        persistenceService.save()
    }
    
    func deleteHydration(hydrationRecord: HydrationRecord, from careRecipient: CareRecipient) {
        hydrationService.deleteHydrationRecord(hydrationRecord: hydrationRecord, from: careRecipient)
        persistenceService.save()
    }
    
    // MARK: - STOOL ACTIONS
    func addStool(period: PeriodEnum, date: Date, format: String, notes: String, color: String, in careRecipient: CareRecipient) {
        stoolService.addStoolRecord(period: period, date: date, format: format, notes: notes, color: color, in: careRecipient)
        persistenceService.save()
    }

    func deleteStool(stoolRecord: StoolRecord, from careRecipient: CareRecipient) {
        stoolService.deleteStoolRecord(stoolRecord: stoolRecord, from: careRecipient)
        persistenceService.save()
    }
    
    // MARK: - URINE ACTIONS
    func addUrine(
        period: PeriodEnum,
        date: Date,
        color: String,
        in careRecipient: CareRecipient,
        urineCharacteristics: [UrineCharacteristicsEnum],
        observation: String?
    ) {
        urineService.addUrineRecord(
            period: period,
            date: date,
            color: color,
            characteristics: urineCharacteristics,
            observation: observation,
            to: careRecipient
        )
        persistenceService.save()
    }

    func updateUrine(
        _ record: UrineRecord,
        period: PeriodEnum? = nil,
        date: Date? = nil,
        color: String? = nil,
        characteristics: [UrineCharacteristicsEnum]? = nil,
        observation: String? = nil
    ) {
        urineService.updateUrineRecord(
            record,
            period: period,
            date: date,
            color: color,
            characteristics: characteristics,
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
}
