//
//  CareRecipient+MentalStateTest.swift
//  Altroo
//
//  Created by Layza Maria Rodrigues Carneiro on 02/10/25.
//

import CoreData
import XCTest
@testable import Altroo

// MARK: - CoreDataService Mock
final class CoreDataServiceMock: CoreDataService {
    var saveCalledCount = 0
    
    override func save() {
        saveCalledCount += 1
    }
}

// MARK: - Mocks for the protocols that CareRecipientFacade asks
class BasicNeedsFacadeMock: BasicNeedsFacadeProtocol {}
class RoutineActivitiesFacadeMock: RoutineActivitiesFacadeProtocol {}

class CareRecipientFacadeTests: XCTestCase {
    
    var sut: CareRecipientFacade!
    var persistenceMock: CoreDataServiceMock!
    var context: NSManagedObjectContext!
    var mentalState: MentalState!
    
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
        
        mentalState = MentalState(context: context)
        
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
        mentalState = nil
        context = nil
        super.tearDown()
    }

    // MARK: - Unit Tests
    func test_addEmotionalState_updatesProperty_andCallsSave() {
        sut.addEmotionalState(emotionalState: [.calm], mentalState: mentalState)
        
        XCTAssertEqual(mentalState.emotionalState?.first, EmotionalStateEnum.calm.rawValue)
        XCTAssertEqual(persistenceMock.saveCalledCount, 1)
    }
    
    func test_addMemoryState_updatesProperty_andCallsSave() {
        sut.addMemoryState(memoryState: .impaired, mentalState: mentalState)
        
        XCTAssertEqual(mentalState.memoryState, MemoryEnum.impaired.rawValue)
        XCTAssertEqual(persistenceMock.saveCalledCount, 1)
    }
    
    func test_addOrientationState_updatesProperty_andCallsSave() {
        sut.addOrientationState(orientationState: [.disorientedInTime], mentalState: mentalState)
        
        XCTAssertEqual(mentalState.orientationState?.first, OrientationEnum.disorientedInTime.rawValue)
        XCTAssertEqual(persistenceMock.saveCalledCount, 1)
    }
    
    func test_addCognitionState_updatesProperty_andCallsSave() {
        sut.addCognitionState(cognitionState: .mediumCapacity, mentalState: mentalState)
        
        XCTAssertEqual(mentalState.cognitionState, CognitionEnum.mediumCapacity.rawValue)
        XCTAssertEqual(persistenceMock.saveCalledCount, 1)
    }
    
    func test_multipleUpdates_shouldAccumulateSaveCalls() {
        sut.addEmotionalState(emotionalState: [.anxious], mentalState: mentalState)
        sut.addMemoryState(memoryState: .intact, mentalState: mentalState)
        
        XCTAssertEqual(mentalState.emotionalState?.first, EmotionalStateEnum.anxious.rawValue)
        XCTAssertEqual(mentalState.memoryState, MemoryEnum.intact.rawValue)
        XCTAssertEqual(persistenceMock.saveCalledCount, 2)
    }
    
    func test_updateAllMentalStates_together() {
        sut.addEmotionalState(emotionalState: [.aggressive], mentalState: mentalState)
        sut.addMemoryState(memoryState: .impaired, mentalState: mentalState)
        sut.addOrientationState(orientationState: [.disorientedInAll], mentalState: mentalState)
        sut.addCognitionState(cognitionState: .lowCapacity, mentalState: mentalState)
        
        XCTAssertEqual(mentalState.emotionalState?.first, EmotionalStateEnum.aggressive.rawValue)
        XCTAssertEqual(mentalState.memoryState, MemoryEnum.impaired.rawValue)
        XCTAssertEqual(mentalState.orientationState?.first, OrientationEnum.disorientedInAll.rawValue)
        XCTAssertEqual(mentalState.cognitionState, CognitionEnum.lowCapacity.rawValue)
        XCTAssertEqual(persistenceMock.saveCalledCount, 4)
    }

    
    // MARK: - Integration test with core data
    func test_addCognitionState_persistsToCoreData() {
        sut.addCognitionState(cognitionState: .mediumCapacity, mentalState: mentalState)
        try? context.save()
        
        let fetch: NSFetchRequest<MentalState> = MentalState.fetchRequest()
        let results = try? context.fetch(fetch)
        
        XCTAssertEqual(results?.first?.cognitionState, CognitionEnum.mediumCapacity.rawValue)
    }
    
    func test_addAllMentalStates_together_persistsToCoreData() {
        sut.addEmotionalState(emotionalState: [.lively], mentalState: mentalState)
        sut.addMemoryState(memoryState: .intact, mentalState: mentalState)
        sut.addOrientationState(orientationState: [.disorientedInSpace], mentalState: mentalState)
        sut.addCognitionState(cognitionState: .mediumCapacity, mentalState: mentalState)

        try? context.save()
        
        let fetch: NSFetchRequest<MentalState> = MentalState.fetchRequest()
        let results = try? context.fetch(fetch)
        
        XCTAssertEqual(results?.first?.emotionalState?.first, EmotionalStateEnum.lively.rawValue)
        XCTAssertEqual(results?.first?.memoryState, MemoryEnum.intact.rawValue)
        XCTAssertEqual(results?.first?.orientationState?.first, OrientationEnum.disorientedInSpace.rawValue)
        XCTAssertEqual(results?.first?.cognitionState, CognitionEnum.mediumCapacity.rawValue)
    }
}
