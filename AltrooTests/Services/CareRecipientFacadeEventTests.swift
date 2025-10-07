//
//  CareRecipientFacadeEventTests.swift
//  Altroo
//
//  Created by Layza Maria Rodrigues Carneiro on 07/10/25.
//

import XCTest
import CoreData
@testable import Altroo

final class CareRecipientFacadeEventTests: XCTestCase {

    var facade: CareRecipientFacade!
    var persistenceMock: CoreDataServiceMock!
    var context: NSManagedObjectContext!
    var careRecipient: CareRecipient!

    override func setUp() {
        super.setUp()

        let container = NSPersistentContainer(name: "AltrooDataModel")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { _, error in
            XCTAssertNil(error)
        }
        
        context = container.viewContext
        
        // Mocks
        persistenceMock = CoreDataServiceMock()
        facade = CareRecipientFacade(
            basicNeedsFacade: BasicNeedsFacadeMock(),
            routineActivitiesFacade: RoutineActivitiesFacadeMock(),
            persistenceService: persistenceMock
        )

        careRecipient = CareRecipient(context: context)
        careRecipient.id = UUID()
        persistenceMock.save()
    }

    override func tearDown() {
        facade = nil
        persistenceMock = nil
        context = nil
        careRecipient = nil
        super.tearDown()
    }

    func testAddMultipleEventsToCareRecipient() {
        // Given
        let event1Start = Date()
        let event1End = event1Start.addingTimeInterval(3600)
        let event2Start = event1End.addingTimeInterval(7200)
        let event2End = event2Start.addingTimeInterval(3600)

        // When
        facade.addEvent(
            name: "Morning Walk",
            category: "Exercise",
            startDate: event1Start,
            endDate: event1End,
            startTime: event1Start,
            endTime: event1End,
            location: "Park",
            note: "Walk with caregiver",
            in: careRecipient
        )

        facade.addEvent(
            name: "Lunch Time",
            category: "Meal",
            startDate: event2Start,
            endDate: event2End,
            startTime: event2Start,
            endTime: event2End,
            location: "Kitchen",
            note: "Vegetarian meal",
            in: careRecipient
        )

        // Then
        let events = careRecipient.events as? Set<CareRecipientEvents>
        XCTAssertEqual(events?.count, 2, "CareRecipient should have 2 events")
    }

    func testDeleteEventFromCareRecipient() {
        // Given
        let start = Date()
        let end = start.addingTimeInterval(3600)

        facade.addEvent(
            name: "Physiotherapy",
            category: "Health",
            startDate: start,
            endDate: end,
            startTime: start,
            endTime: end,
            location: "Clinic",
            note: "Weekly session",
            in: careRecipient
        )

        guard let event = (careRecipient.events as? Set<CareRecipientEvents>)?.first else {
            XCTFail("Event was not created properly")
            return
        }

        // When
        facade.deleteEvent(eventRecord: event, from: careRecipient)

        // Then
        let remainingEvents = careRecipient.events as? Set<CareRecipientEvents>
        XCTAssertEqual(remainingEvents?.count, 0, "Event should have been deleted")
    }
}
