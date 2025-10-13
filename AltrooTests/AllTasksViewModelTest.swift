//
//  AllTasksViewModelTest.swift
//  Altroo
//
//  Created by Raissa Parente on 12/10/25.
//
import XCTest
@testable import Altroo


final class RoutineActivitiesFacadeSpy: RoutineActivitiesFacadeProtocol {
    private(set) var generateInstancesCalled = 0
    private(set) var fetchInstancesCalled = 0
    var instancesToReturn: [TaskInstance] = []

    func generateInstancesForToday(for careRecipient: CareRecipient) {
        generateInstancesCalled += 1
    }

    func fetchAllInstanceRoutineTasks(from careRecipient: CareRecipient) -> [TaskInstance] {
        fetchInstancesCalled += 1
        return instancesToReturn
    }
}

final class AllTasksViewModelTests: XCTestCase {
    func makeDummyTaskInstance(for date: Date, template: RoutineTask) -> TaskInstance {
        let instance = DummyTaskInstance()
        instance.time = date
        instance.template = template
        return instance
    }

//    func test_AllTasksViewModel_loadsTodayInstances_correctly() {
//        let careRecipient = DummyCareRecipient()
//        let facadeSpy = RoutineActivitiesFacadeSpy()
//        
//        //task template
//        let templateToday = DummyRoutineTask()
//        templateToday.startDate = Calendar.current.date(byAdding: .day, value: -1, to: Date())
//        templateToday.endDate = Calendar.current.date(byAdding: .day, value: 1, to: Date())
//        templateToday.weekdays = [Locale.Weekday.from(calendarWeekday: Calendar.current.component(.weekday, from: Date()))!]
//
//        let templateOtherDay = DummyRoutineTask()
//        templateOtherDay.startDate = Calendar.current.date(byAdding: .day, value: -1, to: Date())
//        templateOtherDay.endDate = Calendar.current.date(byAdding: .day, value: 1, to: Date())
//        templateOtherDay.weekdays = [.monday] //today is NOT monday
//
//        //coredata instances
//        let instanceToday = makeDummyTaskInstance(for: Date(), template: templateToday)
//        let instanceOther = makeDummyTaskInstance(for: Date(), template: templateOtherDay)
//        
//        facadeSpy.instancesToReturn = [instanceToday, instanceOther]
//
//        let vm = AllTasksViewModel(taskService: facadeSpy, currentCareRecipient: careRecipient)
//        
//        vm.loadTasks()
//        
//        XCTAssertEqual(facadeSpy.generateInstancesCalled, 1, "Today instances")
//        XCTAssertEqual(facadeSpy.fetchInstancesCalled, 1, "Core Data instances")
//        
//        XCTAssertEqual(vm.tasks.count, 1, "Filtered today instances")
//        XCTAssertTrue(vm.tasks.first?.template === templateToday, "Deveria manter apenas a instância do template válido hoje")
//    }
}

