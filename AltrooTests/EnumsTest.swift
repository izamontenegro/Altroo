//
//  EnumsTest.swift
//  Altroo
//
//  Created by Layza Maria Rodrigues Carneiro on 24/09/25.
//

import XCTest
import CoreData
@testable import Altroo

class EnumsTest: XCTestCase {

    var coreDataStack: CoreDataTestStack!

    override func setUp() {
        super.setUp()
        coreDataStack = CoreDataTestStack()
    }

    override func tearDown() {
        coreDataStack = nil
        super.tearDown()
    }
    
    // MARK: PhysicalStateTest -
    func testVision_whenSettingEnum_storesCorrectString() {
        let physicalState = PhysicalState(context: coreDataStack.managedObjectContext)
        physicalState.vision = .partiallyImpaired

        XCTAssertEqual(physicalState.visionState, VisionEnum.partiallyImpaired.rawValue)
    }

    func testMobility_whenSettingEnum_storesWrongString() {
        let physicalState = PhysicalState(context: coreDataStack.managedObjectContext)
        physicalState.mobility = .humanAssisted
        
        XCTAssertNotEqual(physicalState.mobilityState, MobilityEnum.independent.rawValue)
    }
}

// Helper class for in-memory Core Data
class CoreDataTestStack {
    let persistentContainer: NSPersistentContainer
    let managedObjectContext: NSManagedObjectContext

    init() {
        let model = NSManagedObjectModel.mergedModel(from: [Bundle.main])!

        persistentContainer = NSPersistentContainer(name: "AltrooDataModel", managedObjectModel: model)
        let description = persistentContainer.persistentStoreDescriptions.first
        
        description?.type = NSInMemoryStoreType

        persistentContainer.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        managedObjectContext = persistentContainer.viewContext
    }
}
