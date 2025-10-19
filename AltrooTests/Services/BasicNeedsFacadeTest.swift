//
//  PatientServiceTest.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 30/09/25.
//

import XCTest
@testable import Altroo

// MARK: - CoreDataService Spy
final class CoreDataServiceSpy: CoreDataService {
    private(set) var saveContextCalled = 0
    override func save() {
        saveContextCalled += 1
    }
}

// MARK: - Service Spies
final class FeedingServiceSpy: FeedingServiceProtocol {
    struct AddCaptured {
        var amountEaten: MealAmountEatenEnum?
        var date: Date?
        var period: PeriodEnum?
        var notes: String?
        var photo: Data?
        var mealCategory: MealCategoryEnum?
        var careRecipient: CareRecipient?
    }

    private(set) var addCalled = 0
    private(set) var deleteCalled = 0
    private(set) var lastAdd: AddCaptured?
    private(set) var lastDeleted: (FeedingRecord, CareRecipient)?

    func addFeedingRecord(amountEaten: MealAmountEatenEnum,
                          Date: Date,
                          period: PeriodEnum,
                          notes: String,
                          photo: Data?,
                          mealCategory: MealCategoryEnum,
                          in careRecipient: CareRecipient) {
        addCalled += 1
        lastAdd = .init(
            amountEaten: amountEaten,
            date: Date,
            period: period,
            notes: notes,
            photo: photo,
            mealCategory: mealCategory,
            careRecipient: careRecipient
        )
    }

    func deleteFeedingRecord(feedingRecord: FeedingRecord, from careRecipient: CareRecipient) {
        deleteCalled += 1
        lastDeleted = (feedingRecord, careRecipient)
    }
}

final class HydrationServiceSpy: HydrationServiceProtocol {
    struct AddCaptured {
        var period: PeriodEnum?
        var date: Date?
        var behavior: String?
        var waterQuantity: Double?
        var careRecipient: CareRecipient?
    }
    private(set) var addCalled = 0
    private(set) var deleteCalled = 0
    private(set) var lastAdd: AddCaptured?
    private(set) var lastDeleted: (HydrationRecord, CareRecipient)?

    func addHydrationRecord(period: PeriodEnum, date: Date, behavior: String, waterQuantity: Double, in careRecipient: CareRecipient) {
        addCalled += 1
        lastAdd = .init(period: period, date: date, behavior: behavior, waterQuantity: waterQuantity, careRecipient: careRecipient)
    }

    func deleteHydrationRecord(hydrationRecord: HydrationRecord, from careRecipient: CareRecipient) {
        deleteCalled += 1
        lastDeleted = (hydrationRecord, careRecipient)
    }
}

final class StoolServiceSpy: StoolServiceProtocol {
    struct AddCaptured {
        var period: PeriodEnum?
        var date: Date?
        var format: String?
        var hadPain: Bool?
        var color: String?
        var careRecipient: CareRecipient?
    }
    private(set) var addCalled = 0
    private(set) var deleteCalled = 0
    private(set) var lastAdd: AddCaptured?
    private(set) var lastDeleted: (StoolRecord, CareRecipient)?

    func addStoolRecord(period: PeriodEnum, date: Date, format: String, hadPain: Bool, color: String, in careRecipient: CareRecipient) {
        addCalled += 1
        lastAdd = .init(period: period, date: date, format: format, hadPain: hadPain, color: color, careRecipient: careRecipient)
    }

    func deleteStoolRecord(stoolRecord: StoolRecord, from careRecipient: CareRecipient) {
        deleteCalled += 1
        lastDeleted = (stoolRecord, careRecipient)
    }
}

final class UrineServiceSpy: UrineServiceProtocol {
    struct AddCaptured {
        var period: PeriodEnum?
        var date: Date?
        var hadPain: Bool?
        var color: String?
        var careRecipient: CareRecipient?
    }
    private(set) var addCalled = 0
    private(set) var deleteCalled = 0
    private(set) var lastAdd: AddCaptured?
    private(set) var lastDeleted: (UrineRecord, CareRecipient)?

    func addUrineRecord(period: PeriodEnum, date: Date, hadPain: Bool, color: String, in careRecipient: CareRecipient) {
        addCalled += 1
        lastAdd = .init(period: period, date: date, hadPain: hadPain, color: color, careRecipient: careRecipient)
    }

    func deleteUrineRecord(urineRecord: UrineRecord, from careRecipient: CareRecipient) {
        deleteCalled += 1
        lastDeleted = (urineRecord, careRecipient)
    }
}

// MARK: - Dummy entities
final class DummyCareRecipient: CareRecipient {}
final class DummyFeedingRecord: FeedingRecord {}
final class DummyHydrationRecord: HydrationRecord {}
final class DummyStoolRecord: StoolRecord {}
final class DummyUrineRecord: UrineRecord {}

// MARK: - Tests
final class BasicNeedsFacadeTests: XCTestCase {

    private func makeSUT() -> (sut: BasicNeedsFacade,
                               feeding: FeedingServiceSpy,
                               hydration: HydrationServiceSpy,
                               stool: StoolServiceSpy,
                               urine: UrineServiceSpy,
                               coreData: CoreDataServiceSpy) {
        let coreDataSpy = CoreDataServiceSpy()
        let feedingSpy = FeedingServiceSpy()
        let hydrationSpy = HydrationServiceSpy()
        let stoolSpy = StoolServiceSpy()
        let urineSpy = UrineServiceSpy()

        let sut = BasicNeedsFacade(
            feedingService: feedingSpy,
            hydrationService: hydrationSpy,
            stoolService: stoolSpy,
            urineService: urineSpy,
            persistenceService: coreDataSpy
        )
        return (sut, feedingSpy, hydrationSpy, stoolSpy, urineSpy, coreDataSpy)
    }

    // MARK: Feeding
    func test_addFeeding_callsService_andSaves() {
        let (sut, feedingSpy, _, _, _, coreDataSpy) = makeSUT()
        let care = DummyCareRecipient()
        let now = Date()
        
        sut.addFeeding(
            amountEaten: .all,
            date: now,
            period: .morning,
            notes: "Bottle 120ml",
            mealCategory: .breakfast,
            in: care
        )

        XCTAssertEqual(feedingSpy.addCalled, 1)
        XCTAssertEqual(coreDataSpy.saveContextCalled, 1)

        XCTAssertEqual(feedingSpy.lastAdd?.amountEaten, .all)
        XCTAssertEqual(feedingSpy.lastAdd?.date, now)
        XCTAssertEqual(feedingSpy.lastAdd?.period, .morning)
        XCTAssertEqual(feedingSpy.lastAdd?.notes, "Bottle 120ml")
        XCTAssertEqual(feedingSpy.lastAdd?.mealCategory, .breakfast)
        XCTAssertTrue(feedingSpy.lastAdd?.careRecipient === care)
    }

    // MARK: Hydration
    func test_addHydration_callsService_andSaves() {
        let (sut, _, hydrationSpy, _, _, coreDataSpy) = makeSUT()
        let care = DummyCareRecipient()
        let now = Date()

        sut.addHydration(
            period: .afternoon,
            date: now,
            behavior: "Normal",
            waterQuantity: 0.25,
            in: care
        )

        XCTAssertEqual(hydrationSpy.addCalled, 1)
        XCTAssertEqual(coreDataSpy.saveContextCalled, 1)

        XCTAssertEqual(hydrationSpy.lastAdd?.period, .afternoon)
        XCTAssertEqual(hydrationSpy.lastAdd?.date, now)
        XCTAssertEqual(hydrationSpy.lastAdd?.behavior, "Normal")
        XCTAssertEqual(hydrationSpy.lastAdd?.waterQuantity, 0.25)
        XCTAssertTrue(hydrationSpy.lastAdd?.careRecipient === care)
    }

    func test_deleteHydration_callsService_andSaves() {
        let (sut, _, hydrationSpy, _, _, coreDataSpy) = makeSUT()
        let care = DummyCareRecipient()
        let record = DummyHydrationRecord()

        sut.deleteHydration(hydrationRecord: record, from: care)

        XCTAssertEqual(hydrationSpy.deleteCalled, 1)
        XCTAssertEqual(coreDataSpy.saveContextCalled, 1)
        XCTAssertTrue(hydrationSpy.lastDeleted?.0 === record)
        XCTAssertTrue(hydrationSpy.lastDeleted?.1 === care)
    }

    // MARK: Stool
    func test_addStool_callsService_andSaves() {
        let (sut, _, _, stoolSpy, _, coreDataSpy) = makeSUT()
        let care = DummyCareRecipient()
        let now = Date()

        sut.addStool(
            period: .overnight,
            date: now,
            format: "Solid",
            hadPain: false,
            color: "Brown",
            in: care
        )

        XCTAssertEqual(stoolSpy.addCalled, 1)
        XCTAssertEqual(coreDataSpy.saveContextCalled, 1)

        XCTAssertEqual(stoolSpy.lastAdd?.period, .overnight)
        XCTAssertEqual(stoolSpy.lastAdd?.date, now)
        XCTAssertEqual(stoolSpy.lastAdd?.format, "Solid")
        XCTAssertEqual(stoolSpy.lastAdd?.hadPain, false)
        XCTAssertEqual(stoolSpy.lastAdd?.color, "Brown")
        XCTAssertTrue(stoolSpy.lastAdd?.careRecipient === care)
    }

    func test_deleteStool_callsService_andSaves() {
        let (sut, _, _, stoolSpy, _, coreDataSpy) = makeSUT()
        let care = DummyCareRecipient()
        let record = DummyStoolRecord()

        sut.deleteStool(stoolRecord: record, from: care)

        XCTAssertEqual(stoolSpy.deleteCalled, 1)
        XCTAssertEqual(coreDataSpy.saveContextCalled, 1)
        XCTAssertTrue(stoolSpy.lastDeleted?.0 === record)
        XCTAssertTrue(stoolSpy.lastDeleted?.1 === care)
    }

    // MARK: Urine
    func test_addUrine_callsService_andSaves() {
        let (sut, _, _, _, urineSpy, coreDataSpy) = makeSUT()
        let care = DummyCareRecipient()
        let now = Date()

        sut.addUrine(
            period: .night,
            date: now,
            color: "Light yellow",
            in: care,
            hadPain: true
        )

        XCTAssertEqual(urineSpy.addCalled, 1)
        XCTAssertEqual(coreDataSpy.saveContextCalled, 1)

        XCTAssertEqual(urineSpy.lastAdd?.period, .night)
        XCTAssertEqual(urineSpy.lastAdd?.date, now)
        XCTAssertEqual(urineSpy.lastAdd?.color, "Light yellow")
        XCTAssertEqual(urineSpy.lastAdd?.hadPain, true)
        XCTAssertTrue(urineSpy.lastAdd?.careRecipient === care)
    }

    func test_deleteUrine_callsService_andSaves() {
        let (sut, _, _, _, urineSpy, coreDataSpy) = makeSUT()
        let care = DummyCareRecipient()
        let record = DummyUrineRecord()

        sut.deleteUrine(urineRecord: record, from: care)

        XCTAssertEqual(urineSpy.deleteCalled, 1)
        XCTAssertEqual(coreDataSpy.saveContextCalled, 1)
        XCTAssertTrue(urineSpy.lastDeleted?.0 === record)
        XCTAssertTrue(urineSpy.lastDeleted?.1 === care)
    }
}
