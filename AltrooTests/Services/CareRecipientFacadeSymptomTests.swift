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
    
    func makeTestSymptoms() -> [Symptom] {
        guard let context = careRecipient.managedObjectContext else { return [] }

            let today = Date()
            let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: today)!

            let data: [(String, String, Date)] = [
                ("Headache", "Mild pain", today),
                ("Cough", "Dry cough", today),
                ("Fever", "Low grade", today),
                ("Sore Throat", "Mild irritation", yesterday),
                ("Fatigue", "Feeling tired", yesterday),
                ("Nausea", "Slight nausea", yesterday)
            ]

            return data.map { name, desc, date in
                let symptom = Symptom(context: context)
                symptom.name = name
                symptom.symptomDescription = desc
                symptom.date = date
                symptom.careRecipient = careRecipient
                return symptom
            }
    }
    
    func testAddSingleSymptomToCareRecipient() {
        // Given
        let date = Date()
        
        // When
        facade.addSymptom(name: "Headache", symptomDescription: "Mild pain", date: date, author: "User", in: careRecipient)
        
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
        facade.addSymptom(name: "Headache", symptomDescription: "Mild pain", date: date, author: "User", in: careRecipient)
        facade.addSymptom(name: "Cough", symptomDescription: "Dry cough", date: date, author: "User", in: careRecipient)
        
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
        facade.addSymptom(name: "Headache", symptomDescription: "Mild pain", date: date, author: "User", in: careRecipient)
        
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
    
    func testEditSymptom() {
        // Given
        let date = Date()
        let symptom = facade.addSymptom(name: "Headache", symptomDescription: "Mild pain", date: date, author: "User", in: careRecipient)
        
        // When
        let name = "Cough"
        let description = ""
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: date)!
        facade.editSymptom(symptom: symptom!, name: name, symptomDescription: description, date: tomorrow)
        
        // Then
        XCTAssertEqual(symptom?.name, name)
        XCTAssertEqual(symptom?.symptomDescription, description)
        XCTAssertEqual(symptom?.date, tomorrow)
    }
    
    func testfetchAllSymptoms() {
        let symptoms = makeTestSymptoms() //3 for today, 3 for yesterday
        
        let allAddedSymptoms = facade.fetchAllSymptoms(from: careRecipient)
        
        XCTAssertEqual(allAddedSymptoms.count, symptoms.count)
    }
    
    func testfetchAllTodaySymptoms() {
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        let symptoms = makeTestSymptoms() //3 for today, 3 for yesterday
        
        let todayAddedSymptoms = facade.fetchAllSymptomForDate(Date(), from: careRecipient)
        let yesterdayAddedSymptoms = facade.fetchAllSymptomForDate(yesterday, from: careRecipient)
        
        XCTAssertEqual(todayAddedSymptoms.count, 3)
        XCTAssertEqual(yesterdayAddedSymptoms.count, 3)
    }
    
    func testAddDuplicateSymptoms() {
        let date = Date()
        let s1 = facade.addSymptom(name: "Cough", symptomDescription: "Dry cough", date: date, author: "User", in: careRecipient)
        let s2 = facade.addSymptom(name: "Cough", symptomDescription: "Dry cough", date: date, author: "User", in: careRecipient)
        
        let allSymptoms = facade.fetchAllSymptoms(from: careRecipient)
        XCTAssertEqual(allSymptoms.count, 2)
        XCTAssertTrue(allSymptoms.contains(where: { $0 === s1 }))
        XCTAssertTrue(allSymptoms.contains(where: { $0 === s2 }))
    }

    func testDeleteNonexistentSymptom() {
        let fakeSymptom = Symptom(context: context)
        fakeSymptom.name = "Fake"
        
        XCTAssertNoThrow(facade.deleteSymptom(symptomRecord: fakeSymptom, from: careRecipient))
        
        let remaining = facade.fetchAllSymptoms(from: careRecipient)
        XCTAssertTrue(remaining.isEmpty)
    }
    
    func testFetchSymptomsForEmptyDate() {
        //today’s symptoms
        let today = Date()
        _ = facade.addSymptom(name: "Headache", symptomDescription: "Mild pain", date: today, author: "User", in: careRecipient)
        
        // fetch yesterday
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: today)!
        let fetched = facade.fetchAllSymptomForDate(yesterday, from: careRecipient)
        
        XCTAssertTrue(fetched.isEmpty)
    }


}
