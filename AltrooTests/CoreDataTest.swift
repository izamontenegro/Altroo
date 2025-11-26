//
//  CoreDataTest.swift
//  Altroo
//
//  Created by Layza Maria Rodrigues Carneiro on 23/09/25.
//

import XCTest
import CoreData
@testable import Altroo

class CareRecipientTests: XCTestCase {
    
    var coreDataStack: CoreDataTestStack!
    var context: NSManagedObjectContext!
    
    override func setUp() {
        super.setUp()
        coreDataStack = CoreDataTestStack()
        context = coreDataStack.managedObjectContext
    }
    
    override func tearDown() {
        coreDataStack = nil
        context = nil
        super.tearDown()
    }
    
    func test_careRecipientHasPersonalData() throws {
        // 1. Create entities 'personalData' and 'careRecipient'
        let personalData = PersonalData(context: context)
        personalData.name = "Charles Darwin"
        
        let careRecipient = CareRecipient(context: context)
        
        // 2. Establish the relationship
        careRecipient.personalData = personalData
        
        // 3. Save the context
        try context.save()
        
        // 4. Verify that the relationship is maintained after saving
        let request: NSFetchRequest<CareRecipient> = CareRecipient.fetchRequest()
        let fetchedRecipient = try XCTUnwrap(context.fetch(request).first)
        
        // The relationship must exist
        XCTAssertNotNil(fetchedRecipient.personalData)
        // And the data must be the same
        XCTAssertEqual(fetchedRecipient.personalData?.name, "Charles Darwin")
    }
    
    func test_personalDataHasMultipleContacts() throws {
        let personalData = PersonalData(context: context)
        
        let contact1 = Contact(context: context)
        contact1.name = "Emergency Contact"
        
        let contact2 = Contact(context: context)
        contact2.name = "Family Member"
        
        personalData.addToContacts(contact1)
        personalData.addToContacts(contact2)

        try context.save()
        
        let request: NSFetchRequest<PersonalData> = PersonalData.fetchRequest()
        let fetchedPersonalData = try XCTUnwrap(context.fetch(request).first)
        
        XCTAssertEqual(fetchedPersonalData.contacts?.count, 2)
    }
    
    func testFullCareRecipientLifecycle() throws {
        let careRecipient = CareRecipient(context: context)
        let personalData = PersonalData(context: context)
        let physicalState = PhysicalState(context: context)
        let healthProblems = HealthProblems(context: context)
        
        let calendar = Calendar.current
        let components = DateComponents(year: -75)
        let dateOfBirth = calendar.date(byAdding: components, to: Date())!
        
        personalData.name = "Steve Jobs"
        personalData.dateOfBirth = dateOfBirth
        
        physicalState.visionState = VisionEnum.lowVision.rawValue
        physicalState.mobilityState = MobilityEnum.noAssistance.rawValue
        physicalState.oralHealthState = [OralHealthEnum.allTeethPresent.rawValue]
        
        healthProblems.allergies = "milk, gluten"
        careRecipient.personalData = personalData
        careRecipient.physicalState = physicalState
        careRecipient.healthProblems = healthProblems
        
        try context.save()
                
        let fetchRequest: NSFetchRequest<CareRecipient> = CareRecipient.fetchRequest()
        let fetchedRecipients = try context.fetch(fetchRequest)
        
        XCTAssertEqual(fetchedRecipients.count, 1, "Must have exactly 1 CareRecipient.")
        
        guard let savedRecipient = fetchedRecipients.first else {
            XCTFail("CareRecipient not found after saving.")
            return
        }
        
        XCTAssertEqual(savedRecipient.personalData?.name, "Steve Jobs")
        XCTAssertEqual(savedRecipient.personalData?.age, 75)
        XCTAssertEqual(savedRecipient.physicalState?.oralHealthState?.first, OralHealthEnum.allTeethPresent.rawValue)
        XCTAssertEqual(savedRecipient.physicalState?.mobilityState, MobilityEnum.noAssistance.rawValue)
        XCTAssertEqual(savedRecipient.healthProblems?.allergies, "milk, gluten")
                
        savedRecipient.physicalState?.mobilityState = MobilityEnum.bedridden.rawValue
        
        try context.save()
        
        let updatedRecipients = try context.fetch(fetchRequest)
        guard let updatedRecipient = updatedRecipients.first else {
            XCTFail("CareRecipient not found after update.")
            return
        }
        
        XCTAssertEqual(updatedRecipient.physicalState?.mobilityState, MobilityEnum.bedridden.rawValue)
        
        context.delete(updatedRecipient)
        
        try context.save()
        
        let finalRecipients = try context.fetch(fetchRequest)
        
        XCTAssertEqual(finalRecipients.count, 0, "The CareRecipient should have been successfully deleted.")
    }
}
