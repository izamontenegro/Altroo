//
//  CoreDataTest.swift
//  Altroo
//
//  Created by Layza Maria Rodrigues Carneiro on 23/09/25.
//

import XCTest
import CoreData
import Altroo

class CareRecipientTests: XCTestCase {
    
    var container: NSPersistentContainer!
    var context: NSManagedObjectContext { container.viewContext }
    
    override func setUp() {
        super.setUp()
        container = NSPersistentContainer(name: "AltrooDataModel")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]
        
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Unable to load store into memory: \(error)")
            }
        }
    }
    
    override func tearDown() {
        super.tearDown()
        container = nil
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
    
}
