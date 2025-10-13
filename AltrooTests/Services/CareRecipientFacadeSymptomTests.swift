//
//  CareRecipientFacadeSymptomTests.swift
//  Altroo
//
//  Created by Layza Maria Rodrigues Carneiro on 07/10/25.
//

import XCTest
import CoreData
@testable import Altroo

final class CareRecipientFacadeSymptomTests: XCTestCase {
    
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
        
        persistenceMock = CoreDataServiceMock()
        facade = CareRecipientFacade(
            basicNeedsFacade: BasicNeedsFacadeMock(),
            routineActivitiesFacade: RoutineActivitiesFacadeMock(),
            persistenceService: persistenceMock
        )
        
        careRecipient = CareRecipient(context: context)
        careRecipient.id = UUID()
    }
    
    override func tearDown() {
        persistenceMock = nil
        facade = nil
        careRecipient = nil
        super.tearDown()
    }
    
    func testAddSingleSymptomToCareRecipient() {
        // Given
        let date = Date()
        
        // When
        facade.addSymptom(name: "Headache", symptomDescription: "Mild pain", date: date, in: careRecipient)
        
        // Then
        let symptoms = careRecipient.symptoms as? Set<Symptom> ?? []
        XCTAssertEqual(symptoms.count, 1)
        
        let symptom = symptoms.first!
        XCTAssertEqual(symptom.name, "Headache")
        XCTAssertEqual(symptom.symptomDescription, "Mild pain")
    }
    
    func testAddMultipleSymptomsToCareRecipient() {
        // Given
        let date = Date()
        
        // When
        facade.addSymptom(name: "Headache", symptomDescription: "Mild pain", date: date, in: careRecipient)
        facade.addSymptom(name: "Cough", symptomDescription: "Dry cough", date: date, in: careRecipient)
        
        // Then
        let symptoms = careRecipient.symptoms as? Set<Symptom> ?? []
        XCTAssertEqual(symptoms.count, 2)
        
        let names = symptoms.map { $0.name }
        XCTAssertTrue(names.contains("Headache"))
        XCTAssertTrue(names.contains("Cough"))
    }
    
    func testDeleteSymptomFromCareRecipient() {
        // Given
        let date = Date()
        facade.addSymptom(name: "Headache", symptomDescription: "Mild pain", date: date, in: careRecipient)
        
        guard let symptom = (careRecipient.symptoms as? Set<Symptom>)?.first else {
            XCTFail("Symptom was not created properly")
            return
        }
        
        // When
        facade.deleteSymptom(symptomRecord: symptom, from: careRecipient)
        
        // Then
        let remainingSymptoms = careRecipient.symptoms as? Set<Symptom> ?? []
        XCTAssertTrue(remainingSymptoms.isEmpty)
    }
}
