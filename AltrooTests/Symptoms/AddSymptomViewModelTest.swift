////
////  AddSymptomViewModelTest.swift
////  Altroo
////
////  Created by Raissa Parente on 15/10/25.
////
//import XCTest
//import CoreData
//@testable import Altroo
//
//
//final class AddSymptomViewModelTests: XCTestCase {
//    
//    var facade: CareRecipientFacade!
//    var userService: UserServiceSession!
//    var persistenceMock: CoreDataServiceMock!
//    var context: NSManagedObjectContext!
//    var vm: AddSymptomViewModel!
//    
//    override func setUp() {
//        super.setUp()
//        
//        let container = NSPersistentContainer(name: "AltrooDataModel")
//        let description = NSPersistentStoreDescription()
//        description.type = NSInMemoryStoreType
//        container.persistentStoreDescriptions = [description]
//        container.loadPersistentStores { _, error in
//            XCTAssertNil(error)
//        }
//        
//        context = container.viewContext
//        
//        persistenceMock = CoreDataServiceMock()
//        facade = CareRecipientFacade(
//            basicNeedsFacade: BasicNeedsFacadeMock(),
//            routineActivitiesFacade: RoutineActivitiesFacadeMock(),
//            persistenceService: persistenceMock
//        )
//        
//        userService = UserServiceSession(context: context)
//        
//        
//        let careRecipient = CareRecipient(context: context)
//        careRecipient.id = UUID()
//        
//        vm = AddSymptomViewModel(careRecipientFacade: facade, userService: userService)
//        vm.currentCareRecipient = careRecipient
//    }
//
//    
//    override func tearDown() {
//        vm = nil
//        facade = nil
//        userService = nil
//        persistenceMock = nil
//        context = nil
//        super.tearDown()
//    }
//    
//    func testCreateSymptom_withEmptyName_shouldReturnFalse() {
//        vm.name = ""
//        vm.note = "Some note"
//        
//        let result = vm.createSymptom()
//        
//        XCTAssertFalse(result)
//        XCTAssertNotNil(vm.nameError)
//    }
//    
//    func testCreateSymptom_withFutureDate_shouldReturnFalse() {
//        vm.name = "Headache"
//        vm.note = "Note"
//        vm.date = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
//        vm.time = Date()
//        
//        let result = vm.createSymptom()
//        
//        XCTAssertFalse(result)
//        XCTAssertNotNil(vm.dateError)
//    }
//    
//    func testCreateSymptom_withValidData_shouldCallFacade() {
//        vm.name = "Cough"
//        vm.note = "Dry cough"
//        vm.date = Date()
//        vm.time = Date()
//        
//        let result = vm.createSymptom()
//        let lastSymptom = vm.careRecipientFacade.fetchAllSymptoms(from: vm.currentCareRecipient!).last
//        
//        XCTAssertTrue(result)
//        XCTAssertEqual(lastSymptom?.name, "Cough")
//        XCTAssertEqual(lastSymptom?.symptomDescription, "Dry cough")
//    }
//    
//    func testFullDate_combinesDateAndTime() {
//        let calendar = Calendar.current
//        var dateComponents = DateComponents()
//        dateComponents.year = 2025
//        dateComponents.month = 10
//        dateComponents.day = 15
//        dateComponents.hour = 14
//        dateComponents.minute = 30
//        
//        let dateOnly = calendar.date(from: dateComponents)!
//        let timeOnly = calendar.date(from: DateComponents(hour: 16, minute: 45))!
//        
//        vm.date = dateOnly
//        vm.time = timeOnly
//        
//        let fullDate = vm.fullDate
//        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: fullDate)
//        
//        XCTAssertEqual(components.year, 2025)
//        XCTAssertEqual(components.month, 10)
//        XCTAssertEqual(components.day, 15)
//        XCTAssertEqual(components.hour, 16)
//        XCTAssertEqual(components.minute, 45)
//    }
//}
