////
////  UserServiceTests.swift
////  Altroo
////
////  Created by Layza Maria Rodrigues Carneiro on 11/10/25.
////
//
//import XCTest
//import CoreData
//@testable import Altroo
//
//final class UserServiceTests: XCTestCase {
//    
//    var context: NSManagedObjectContext!
//    var userService: UserServiceSession!
//    
//    override func setUp() {
//        super.setUp()
//        
//        let container = NSPersistentContainer(name: "AltrooDataModel")
//        let description = NSPersistentStoreDescription()
//        description.type = NSInMemoryStoreType
//        container.persistentStoreDescriptions = [description]
//        
//        container.loadPersistentStores { _, error in
//            if let error = error {
//                XCTFail("Error loading store into memory: \(error)")
//            }
//        }
//        
//        context = container.viewContext
//        userService = UserServiceSession(context: context)
//    }
//    
//    override func tearDown() {
//        context = nil
//        userService = nil
//        super.tearDown()
//    }
//    
//    // MARK: - Tests
//    private func createUser(name: String = "Amy", category: String = "Caregiver") -> User {
//        let user = User(context: context)
//        user.name = name
//        user.category = category
//        return user
//    }
//    
//    private func createCareRecipient(name: String = "Elton") -> CareRecipient {
//        let patient = CareRecipient(context: context)
//        
//        if let entity = NSEntityDescription.entity(forEntityName: "PersonalData", in: context) {
//            let personalData = NSManagedObject(entity: entity, insertInto: context)
//            personalData.setValue(name, forKey: "name")
//            patient.setValue(personalData, forKey: "personalData")
//            patient.setValue(UUID(), forKey: "id")
//        } else {
//            patient.setValue(name, forKey: "name")
//            patient.setValue(UUID(), forKey: "id")
//        }
//        
//        return patient
//    }
//        
//    func test_fetchUser_returnsUser_whenExists() {
//        let user = createUser()
//        try? context.save()
//        
//        let fetched = userService.fetchUser()
//        XCTAssertEqual(fetched?.name, user.name)
//        XCTAssertEqual(fetched?.category, user.category)
//    }
//    
//    func test_fetchUser_returnsNil_whenNoUserExists() {
//        let fetched = userService.fetchUser()
//        XCTAssertNil(fetched)
//    }
//    
//    func test_setCurrentPatient_updatesUserActiveCareRecipient() {
//        let user = createUser(name: "User", category: "Caregiver")
//        let patient = createCareRecipient(name: "Elton")
//        userService.addPatient(patient)
//        userService.setCurrentPatient(patient)
//        try? context.save()
//        
//        let fetchedUser = userService.fetchUser()
//        let fetchCareRecipient = userService.fetchCareRecipient(id: fetchedUser?.activeCareRecipient ?? UUID())
//        XCTAssertEqual(fetchCareRecipient?.personalData?.name, "Elton")
//    }
//    
//    func test_setName_updatesUserName() {
//        let _ = createUser(name: "Amy")
//        try? context.save()
//        
//        userService.setName("Marilyn")
//        
//        let updatedUser = userService.fetchUser()
//        XCTAssertEqual(updatedUser?.name, "Marilyn")
//    }
//    
//    func test_setCategory_updatesUserCategory() {
//        let user = createUser(category: "Caregiver")
//        try? context.save()
//        
//        userService.setCategory("Family Member")
//        
//        let updatedUser = userService.fetchUser()
//        XCTAssertEqual(updatedUser?.category, "Family Member")
//    }
//    
//    func test_addPatient_addsToUserList() {
//        let _ = createUser()
//        let patient = createCareRecipient(name: "Jake")
//        try? context.save()
//        
//        userService.addPatient(patient)
//        
//        let fetchedPatients = userService.fetchPatients()
//        XCTAssertTrue(fetchedPatients.contains(where: {
//            ($0.value(forKeyPath: "personalData.name") as? String) == "Jake"
//        }))
//    }
//    
////    func test_removePatient_removesFromUserList() {
////        let user = createUser()
////        let patient1 = createCareRecipient(name: "Jake")
////        let patient2 = createCareRecipient(name: "Ryan")
////        user.addToCareRecipient(patient1)
////        user.addToCareRecipient(patient2)
////        try? context.save()
////        
////        userService.removePatient(patient1)
////        
////        let fetchedPatients = userService.fetchPatients()
////        let names = fetchedPatients.compactMap { $0.value(forKeyPath: "personalData.name") as? String }
////        XCTAssertFalse(names.contains("Jake"))
////        XCTAssertTrue(names.contains("Ryan"))
////    }
//    
//    func test_fetchPatients_returnsAllPatients() {
//        let user = createUser()
//        let patient1 = createCareRecipient(name: "John")
//        let patient2 = createCareRecipient(name: "Marie")
//        userService.addPatient(patient1)
//        userService.addPatient(patient2)
//        try? context.save()
//        
//        let patients = userService.fetchPatients()
//        let names = patients.compactMap { $0.value(forKeyPath: "personalData.name") as? String }
//        
//        XCTAssertTrue(names.contains("John"))
//        XCTAssertTrue(names.contains("Marie"))
//        XCTAssertEqual(names.count, 2)
//    }
//    
//    func test_createUser_createsAndSavesUser() {
//        let user = userService.createUser(name: "Ramon", category: "Family Member")
//        
//        XCTAssertNotNil(user.objectID)
//        XCTAssertEqual(user.name, "Ramon")
//        XCTAssertEqual(user.category, "Family Member")
//        
//        let fetched = userService.fetchUser()
//        XCTAssertEqual(fetched?.name, "Ramon")
//        XCTAssertEqual(fetched?.category, "Family Member")
//    }
//
//    func test_changeUserData() {
//        let user = userService.createUser(name: "Ramon", category: "Family Member")
//        
//        XCTAssertNotNil(user.objectID)
//        XCTAssertEqual(user.name, "Ramon")
//        XCTAssertEqual(user.category, "Family Member")
//        
//        userService.setName("Chris")
//        userService.setCategory("Caregiver")
//        
//        let updatedUser = userService.fetchUser()
//        XCTAssertEqual(updatedUser?.name, "Chris")
//        XCTAssertEqual(updatedUser?.category, "Caregiver")
//    }
//    
//    func test_fetchCurrentPatient_returnsPatient_whenExists() {
//        let user = createUser()
//        let patient = createCareRecipient(name: "John")
//        userService.addPatient(patient)
//        userService.setCurrentPatient(patient)
//        try? context.save()
//        
//        let currentPatient = userService.fetchCurrentPatient()
//        XCTAssertNotNil(currentPatient)
//        XCTAssertEqual(currentPatient?.value(forKeyPath: "personalData.name") as? String, "John")
//    }
//
//    func test_fetchCurrentPatient_returnsNil_whenNoPatient() {
//        let user = createUser()
//        try? context.save()
//        
//        let currentPatient = userService.fetchCurrentPatient()
//        XCTAssertNil(currentPatient)
//    }
//
//    func test_removeCurrentPatient_removesActivePatient() {
//        let user = createUser()
//        let patient = createCareRecipient(name: "Jake")
////        user.addToCareRecipient(patient)
//        userService.setCurrentPatient(patient)
//        try? context.save()
//        
//        userService.removeCurrentPatient()
//        
//        let currentPatient = userService.fetchCurrentPatient()
//        XCTAssertNil(currentPatient)
//    }
//
//}
