//
//  CareRecipient+PhysicalStateTests.swift
//  AltrooTests
//
//  Created by Layza Maria Rodrigues Carneiro on 02/10/25.
//

import XCTest
import CoreData
@testable import Altroo

final class CareRecipientPhysicalStateTests: XCTestCase {
    
    var sut: CareRecipientFacade!
    var persistenceMock: CoreDataServiceMock!
    var context: NSManagedObjectContext!
    var physicalState: PhysicalState!
    
    override func setUp() {
        super.setUp()
        
        // Core Data in-memory
        let container = NSPersistentContainer(name: "AltrooDataModel")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { _, error in
            XCTAssertNil(error)
        }
        context = container.viewContext
        
        physicalState = PhysicalState(context: context)
        
        persistenceMock = CoreDataServiceMock()
        sut = CareRecipientFacade(
            basicNeedsFacade: BasicNeedsFacadeMock(),
            routineActivitiesFacade: RoutineActivitiesFacadeMock(),
            persistenceService: persistenceMock
        )
    }
    
    override func tearDown() {
        sut = nil
        persistenceMock = nil
        physicalState = nil
        context = nil
        super.tearDown()
    }
    
    // MARK: - Unit Tests
    func test_addVisionState_updatesProperty_andCallsSave() {
        sut.addVisionState(visionState: .lowVision, physicalState: physicalState)
        XCTAssertEqual(physicalState.visionState, VisionEnum.lowVision.rawValue)
        XCTAssertEqual(persistenceMock.saveCalledCount, 1)
    }
    
    func test_addHearingState_updatesProperty_andCallsSave() {
        sut.addHearingState(hearingState: .withDeficit, physicalState: physicalState)
        XCTAssertEqual(physicalState.hearingState, HearingEnum.withDeficit.rawValue)
        XCTAssertEqual(persistenceMock.saveCalledCount, 1)
    }
    
    func test_addOralHealthState_updatesProperty_andCallsSave() {
        sut.addOralHealthState(oralHealthState: .allTeethPresent, physicalState: physicalState)
        XCTAssertEqual(physicalState.oralHealthState, OralHealthEnum.allTeethPresent.rawValue)
        XCTAssertEqual(persistenceMock.saveCalledCount, 1)
    }
    
    func test_addMobilityState_updatesProperty_andCallsSave() {
        sut.addMobilityState(mobilityState: .bedridden, physicalState: physicalState)
        XCTAssertEqual(physicalState.mobilityState, MobilityEnum.bedridden.rawValue)
        XCTAssertEqual(persistenceMock.saveCalledCount, 1)
    }

    func test_updateAllPhysicalStates_together() {
        sut.addVisionState(visionState: .lowVision, physicalState: physicalState)
        sut.addHearingState(hearingState: .withDeficit, physicalState: physicalState)
        sut.addOralHealthState(oralHealthState: .someTeethMissing, physicalState: physicalState)
        sut.addMobilityState(mobilityState: .bedridden, physicalState: physicalState)
        
        XCTAssertEqual(physicalState.visionState, VisionEnum.lowVision.rawValue)
        XCTAssertEqual(physicalState.hearingState, HearingEnum.withDeficit.rawValue)
        XCTAssertEqual(physicalState.oralHealthState, OralHealthEnum.someTeethMissing.rawValue)
        XCTAssertEqual(physicalState.mobilityState, MobilityEnum.bedridden.rawValue)
        XCTAssertEqual(persistenceMock.saveCalledCount, 4)
    }
    
    // MARK: - Integration tests
    func test_addAllPhysicalStates_together_persistsToCoreData() {
        sut.addVisionState(visionState: .lowVision, physicalState: physicalState)
        sut.addHearingState(hearingState: .withDeficit, physicalState: physicalState)
        sut.addOralHealthState(oralHealthState: .allTeethPresent, physicalState: physicalState)
        sut.addMobilityState(mobilityState: .bedridden, physicalState: physicalState)
        
        try? context.save()
        
        let fetch: NSFetchRequest<PhysicalState> = PhysicalState.fetchRequest()
        let results = try? context.fetch(fetch)
        
        XCTAssertEqual(results?.first?.visionState, VisionEnum.lowVision.rawValue)
        XCTAssertEqual(results?.first?.hearingState, HearingEnum.withDeficit.rawValue)
        XCTAssertEqual(results?.first?.oralHealthState, OralHealthEnum.allTeethPresent.rawValue)
        XCTAssertEqual(results?.first?.mobilityState, MobilityEnum.bedridden.rawValue)
    }
}
