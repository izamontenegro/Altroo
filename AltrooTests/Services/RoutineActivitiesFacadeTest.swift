//
//  RoutineActivitiesFacadeTest.swift
//  Altroo
//
//  Created by Layza Maria Rodrigues Carneiro on 07/10/25.
//

import XCTest
@testable import Altroo

// MARK: - Service Spies
final class MeasurementServiceSpy: MeasurementServiceProtocol {
    struct AddCaptured {
        var name: String?
        var unit: String?
        var value: Double?
        var time: Date?
        var frequency: FrequencyEnum?
        var reminder: Bool?
        var status: StatusEnum?
        var careRecipient: CareRecipient?
    }
    private(set) var addCalled = 0
    private(set) var deleteCalled = 0
    private(set) var lastAdd: AddCaptured?
    private(set) var lastDeleted: (Measurements, CareRecipient)?
    
    
    func addMeasurement(name: String, unit: String, value: Double, time: Date, frequency: FrequencyEnum, reminder: Bool, status: StatusEnum, in careRecipient: CareRecipient) {
        addCalled += 1
        lastAdd = .init(name: name, unit: unit, value: value, time: time, frequency: frequency, reminder: reminder, status: status, careRecipient: careRecipient)
    }
    
    func deleteMeasurement(measurement: Measurements, from careRecipient: CareRecipient) {
        deleteCalled += 1
        lastDeleted = (measurement, careRecipient)
    }
}

final class MedicationServiceSpy: MedicationServiceProtocol {
    struct AddCaptured {
        var name: String?
        var quantity: Double?
        var unit: String?
        var time: Date?
        var frequency: FrequencyEnum?
        var reminder: Bool?
        var note: String?
        var doctor: String?
        var photo: Data?
        var dose: String?
        var careRecipient: CareRecipient?
    }
    private(set) var addCalled = 0
    private(set) var deleteCalled = 0
    private(set) var lastAdd: AddCaptured?
    private(set) var lastDeleted: (Medication, CareRecipient)?
    
    
    func addMedication(name: String, quantity: Double, unit: String, time: Date, frequency: FrequencyEnum, reminder: Bool, note: String, doctor: String, photo: Data, dose: String, in careRecipient: CareRecipient) {
        addCalled += 1
        lastAdd = .init(name: name, quantity: quantity, unit: unit, time: time, frequency: frequency, reminder: reminder, note: note, doctor: doctor, photo: photo, dose: dose, careRecipient: careRecipient)
    }
    
    func deleteMedication(medication: Medication, from careRecipient: CareRecipient) {
        deleteCalled += 1
        lastDeleted = (medication, careRecipient)
    }
}

final class RoutineTaskServiceSpy: RoutineTaskServiceProtocol {
    //Template
    struct AddCaptured {
        var task: RoutineTask?
        var name: String?
        var allTimes: [DateComponents]?
        var daysOfTheWeek: [Locale.Weekday]?
        var startDate: Date?
        var endDate: Date?
        var reminder: Bool?
        var note: String?
        var careRecipient: CareRecipient?
    }
    private(set) var addCalled = 0
    private(set) var deleteCalled = 0
    private(set) var editCalled = 0
    private(set) var lastAdd: AddCaptured?
    private(set) var lastDeleted: (RoutineTask, CareRecipient)?
    private(set) var lastEdit: AddCaptured?

    
    func addTemplateRoutineTask(
            name: String,
            allTimes: [DateComponents],
            daysOfTheWeek: [Locale.Weekday],
            startDate: Date,
            endDate: Date?,
            reminder: Bool,
            note: String,
            in careRecipient: CareRecipient
        ) {
            addCalled += 1
            lastAdd = .init(
                name: name,
                allTimes: allTimes,
                daysOfTheWeek: daysOfTheWeek,
                startDate: startDate,
                endDate: endDate,
                reminder: reminder,
                note: note,
                careRecipient: careRecipient
            )
    }
    
    func editTemplateRoutineTask(
         task: RoutineTask,
         name: String,
         allTimes: [DateComponents],
         daysOfTheWeek: [Locale.Weekday],
         startDate: Date,
         endDate: Date?,
         reminder: Bool,
         note: String)
    {
        editCalled += 1
        lastEdit = .init(
            task: task,
            name: name,
            allTimes: allTimes,
            daysOfTheWeek: daysOfTheWeek,
            startDate: startDate,
            endDate: endDate,
            reminder: reminder,
            note: note,
            careRecipient: nil
        )
    }
    
    func deleteRoutineTask(routineTask: RoutineTask, from careRecipient: CareRecipient) {
        deleteCalled += 1
        lastDeleted = (routineTask, careRecipient)
    }
    
    func fetchRoutineTasks(for careRecipient: CareRecipient) -> [RoutineTask] {
        return []
    }
    
    //Instance
    struct AddInstanceCaptured {
        var template: RoutineTask?
        var date: Date?
    }

    private(set) var addInstanceCalled = 0
    private(set) var lastInstanceAdd: AddInstanceCaptured?
    private(set) var toggleCalled = 0
    private(set) var deleteInstanceCalled = 0
    private(set) var lastDeletedInstance: TaskInstance?
    private(set) var lastToggledInstance: TaskInstance?

    
    func addInstanceRoutineTask(from template: RoutineTask, on date: Date) {
        addInstanceCalled += 1
        lastInstanceAdd = .init(template: template, date: date)
    }
    
    func fetchInstanceRoutineTasks(for careRecipient: CareRecipient) -> [TaskInstance] {
        return []
    }
    
    
    func deleteInstanceRoutineTask(_ instance: TaskInstance) {
        deleteInstanceCalled += 1
        lastDeletedInstance = instance
    }
    
    
    func toggleInstanceIsDone(_ instance: TaskInstance) {
        toggleCalled += 1
            lastToggledInstance = instance
    }
}


// MARK: - Dummy entities
final class DummyMeasurements: Measurements {}
final class DummyMedication: Medication {}
final class DummyRoutineTask: RoutineTask {}
final class DummyTaskInstance: TaskInstance {}

//
// MARK: - Tests
final class RoutineActivitiesFacadeTests: XCTestCase {

    private func makeSUT() -> (sut: RoutineActivitiesFacade,
                               measurements: MeasurementServiceSpy,
                               medication: MedicationServiceSpy,
                               routineTask: RoutineTaskServiceSpy,
                               coreData: CoreDataServiceSpy) {
        let coreDataSpy = CoreDataServiceSpy()
        let measurementsSpy = MeasurementServiceSpy()
        let medicationSpy = MedicationServiceSpy()
        let routineTaskSpy = RoutineTaskServiceSpy()

        let sut = RoutineActivitiesFacade(
            routineTaskService: routineTaskSpy,
            medicationService: medicationSpy,
            measurementService: measurementsSpy,
            persistenceService: coreDataSpy
        )
        return (sut, measurementsSpy, medicationSpy, routineTaskSpy, coreDataSpy)
    }

    // MARK: Measurements
    func test_addMeasurements_callsService_andSaves() {
        let (sut, measurementSpy, _, _, coreDataSpy) = makeSUT()
        let care = DummyCareRecipient()
        let now = Date()

        sut.addMeasurement(name: "glicemy", unit: "mg", value: 5, time: now, frequency: .biweekly, reminder: true, status: .beforeLunch, in: care)

        XCTAssertEqual(measurementSpy.addCalled, 1)
        XCTAssertEqual(coreDataSpy.saveContextCalled, 1)

        XCTAssertEqual(measurementSpy.lastAdd?.name, "glicemy")
        XCTAssertEqual(measurementSpy.lastAdd?.unit, "mg")
        XCTAssertEqual(measurementSpy.lastAdd?.value, 5)
        XCTAssertEqual(measurementSpy.lastAdd?.time, now)
        XCTAssertEqual(measurementSpy.lastAdd?.frequency, .biweekly)
        XCTAssertEqual(measurementSpy.lastAdd?.reminder, true)
        XCTAssertEqual(measurementSpy.lastAdd?.status, .beforeLunch)
        XCTAssertTrue(measurementSpy.lastAdd?.careRecipient === care)
    }

    func test_deleteMeasurement_callsService_andSaves() {
        let (sut, measurementSpy, _, _, coreDataSpy) = makeSUT()
        let care = DummyCareRecipient()
        let record = DummyMeasurements()

        sut.deleteMeasurement(measurement: record, from: care)

        XCTAssertEqual(measurementSpy.deleteCalled, 1)
        XCTAssertEqual(coreDataSpy.saveContextCalled, 1)
        XCTAssertTrue(measurementSpy.lastDeleted?.0 === record)
        XCTAssertTrue(measurementSpy.lastDeleted?.1 === care)
    }
    
    // MARK: - Medication
    func test_addMedication_callsService_andSaves() {
        let (sut, _, medicationSpy, _, coreDataSpy) = makeSUT()
        let care = DummyCareRecipient()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        let medicationTime = formatter.date(from: "2025/10/08 08:00")!

        sut.addMedication(
            name: "Loratadine",
            quantity: 1.0,
            unit: "tablet",
            time: medicationTime,
            frequency: .daily,
            reminder: true,
            note: "Take after breakfast. Avoid driving after use.",
            doctor: "Dr. Richard",
            photo: UIImage(named: "loratadine")?.jpegData(compressionQuality: 0.8) ?? Data(),
            dose: "10 mg",
            in: care
        )
        
        XCTAssertEqual(medicationSpy.addCalled, 1)
        XCTAssertEqual(coreDataSpy.saveContextCalled, 1)

        XCTAssertEqual(medicationSpy.lastAdd?.name, "Loratadine")
        XCTAssertEqual(medicationSpy.lastAdd?.quantity, 1.0)
        XCTAssertEqual(medicationSpy.lastAdd?.unit, "tablet")
        XCTAssertEqual(medicationSpy.lastAdd?.time, medicationTime)
        XCTAssertEqual(medicationSpy.lastAdd?.frequency, .daily)
        XCTAssertEqual(medicationSpy.lastAdd?.reminder, true)
        XCTAssertEqual(medicationSpy.lastAdd?.note, "Take after breakfast. Avoid driving after use.")
        XCTAssertEqual(medicationSpy.lastAdd?.doctor, "Dr. Richard")
        XCTAssertEqual(medicationSpy.lastAdd?.photo, UIImage(named: "loratadine")?.jpegData(compressionQuality: 0.8) ?? Data())
        XCTAssertEqual(medicationSpy.lastAdd?.dose, "10 mg")
        XCTAssertTrue(medicationSpy.lastAdd?.careRecipient === care)
    }

    func test_deleteMedication_callsService_andSaves() {
        let (sut, _, medicationSpy, _, coreDataSpy) = makeSUT()
        let care = DummyCareRecipient()
        let record = DummyMedication()

        sut.deleteMedication(medication: record, from: care)

        XCTAssertEqual(medicationSpy.deleteCalled, 1)
        XCTAssertEqual(coreDataSpy.saveContextCalled, 1)
        XCTAssertTrue(medicationSpy.lastDeleted?.0 === record)
        XCTAssertTrue(medicationSpy.lastDeleted?.1 === care)
    }
    
    // MARK: - RoutineTask
    func test_addRoutineTask_callsService_andSaves() {
        let (sut, _, _, routineTaskServiceSpy, coreDataSpy) = makeSUT()
        let care = DummyCareRecipient()

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        let routineTime = formatter.date(from: "2025/10/10 07:00")!
        
        let allTimes = [DateComponents(hour: 8, minute: 30)]
            let days: [Locale.Weekday] = [.monday, .wednesday, .friday]
            let start = Date()
            let end = Calendar.current.date(byAdding: .day, value: 10, to: start)

        sut.addTemplateRoutineTask(
                name: "Morning Bath",
                allTimes: allTimes,
                daysOfTheWeek: days,
                startDate: start,
                endDate: end,
                reminder: false,
                note: "Use lavender soap",
                in: care
        )

        XCTAssertEqual(routineTaskServiceSpy.addCalled, 1)
        XCTAssertEqual(coreDataSpy.saveContextCalled, 1)

        XCTAssertEqual(routineTaskServiceSpy.lastAdd?.name, "Morning Bath")
        XCTAssertEqual(routineTaskServiceSpy.lastAdd?.allTimes?.first?.hour, 8)
        XCTAssertEqual(routineTaskServiceSpy.lastAdd?.daysOfTheWeek, days)
        XCTAssertEqual(routineTaskServiceSpy.lastAdd?.reminder, false)
        XCTAssertEqual(routineTaskServiceSpy.lastAdd?.note, "Use lavender soap")
        XCTAssertTrue(routineTaskServiceSpy.lastAdd?.careRecipient === care)
    }
    
    func test_editRoutineTask_callsService_andSaves() {
        let (sut, _, _, routineTaskSpy, coreDataSpy) = makeSUT()
        let task = DummyRoutineTask()
        let allTimes = [DateComponents(hour: 9, minute: 0)]
        let days: [Locale.Weekday] = [.tuesday, .thursday]
        let start = Date()
        let end = Calendar.current.date(byAdding: .day, value: 5, to: start)
        
        sut.editTemplateRoutineTask(
            task: task,
            name: "Updated Morning Routine",
            allTimes: allTimes,
            daysOfTheWeek: days,
            startDate: start,
            endDate: end,
            reminder: true,
            note: "New note here"
        )
        
        XCTAssertEqual(routineTaskSpy.editCalled, 1)
        XCTAssertEqual(coreDataSpy.saveContextCalled, 1)
        XCTAssertTrue(routineTaskSpy.lastEdit?.task === task)
        XCTAssertEqual(routineTaskSpy.lastEdit?.name, "Updated Morning Routine")
        XCTAssertEqual(routineTaskSpy.lastEdit?.allTimes?.first?.hour, 9)
        XCTAssertEqual(routineTaskSpy.lastEdit?.daysOfTheWeek, days)
        XCTAssertEqual(routineTaskSpy.lastEdit?.reminder, true)
        XCTAssertEqual(routineTaskSpy.lastEdit?.note, "New note here")
    }

    func test_deleteRoutineTask_callsService_andSaves() {
        let (sut, _, _, routineTaskSpy, coreDataSpy) = makeSUT()
        let care = DummyCareRecipient()
        let record = DummyRoutineTask()

        sut.deleteRoutineTask(routineTask: record, from: care)

        XCTAssertEqual(routineTaskSpy.deleteCalled, 1)
        XCTAssertEqual(coreDataSpy.saveContextCalled, 1)
        XCTAssertTrue(routineTaskSpy.lastDeleted?.0 === record)
        XCTAssertTrue(routineTaskSpy.lastDeleted?.1 === care)
    }
    
    func test_addInstanceRoutineTask_callsService_andSaves() {
        let (sut, _, _, routineTaskSpy, coreDataSpy) = makeSUT()
        let template = DummyRoutineTask()
        let instanceDate = Date()

        sut.addInstanceRoutineTask(from: template, on: instanceDate)

        XCTAssertEqual(routineTaskSpy.addInstanceCalled, 1)
        XCTAssertEqual(coreDataSpy.saveContextCalled, 1)
        XCTAssertTrue(routineTaskSpy.lastInstanceAdd?.template === template)
        XCTAssertEqual(routineTaskSpy.lastInstanceAdd?.date, instanceDate)
    }
    
    func test_toggleInstanceIsDone_callsService_andSaves() {
        let (sut, _, _, routineTaskSpy, coreDataSpy) = makeSUT()
        let instance = DummyTaskInstance()

        sut.toggleInstanceIsDone(instance)

        XCTAssertEqual(routineTaskSpy.toggleCalled, 1)
        XCTAssertEqual(coreDataSpy.saveContextCalled, 1)
        XCTAssertEqual(routineTaskSpy.lastToggledInstance?.id, instance.id)
    }

    
    func test_deleteInstanceRoutineTask_callsService_andRecordsInstance() {
        let (sut, _, _, routineTaskSpy, coreDataSpy) = makeSUT()
        let instance = DummyTaskInstance()
        
        sut.deleteInstanceRoutineTask(instance)
        
        XCTAssertEqual(routineTaskSpy.deleteInstanceCalled, 1)
        XCTAssertEqual(coreDataSpy.saveContextCalled, 1)
        XCTAssertTrue(routineTaskSpy.lastDeletedInstance === instance)
    }


}
