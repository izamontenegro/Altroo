//
//  RoutineActivitiesFacade.swift
//  Altroo
//
//  Created by Layza Maria Rodrigues Carneiro on 02/10/25.
//

import Foundation

class RoutineActivitiesFacade: RoutineActivitiesFacadeProtocol {
    private let persistenceService: CoreDataService
    
    private let routineTaskService: RoutineTaskServiceProtocol
    private let medicationService: MedicationServiceProtocol
    private let measurementService: MeasurementServiceProtocol
    
    init(routineTaskService: RoutineTaskServiceProtocol, medicationService: MedicationServiceProtocol, measurementService: MeasurementServiceProtocol, persistenceService: CoreDataService) {
        self.routineTaskService = routineTaskService
        self.medicationService = medicationService
        self.measurementService = measurementService
        self.persistenceService = persistenceService
    }
    
    // MARK: - TASK ACTIONS
    func addTemplateRoutineTask(name: String, allTimes: [DateComponents], daysOfTheWeek: [Locale.Weekday], startDate: Date, endDate: Date?, reminder: Bool, note: String, in careRecipient: CareRecipient) {
        routineTaskService.addTemplateRoutineTask(name: name, allTimes: allTimes, daysOfTheWeek: daysOfTheWeek, startDate: startDate, endDate: endDate, reminder: reminder, note: note, in: careRecipient)
        
        persistenceService.save()
    }
    
    func editTemplateRoutineTask(task: RoutineTask, name: String, allTimes: [DateComponents], daysOfTheWeek: [Locale.Weekday], startDate: Date, endDate: Date?, reminder: Bool, note: String) {
        routineTaskService.editTemplateRoutineTask(task: task, name: name, allTimes: allTimes, daysOfTheWeek: daysOfTheWeek, startDate: startDate, endDate: endDate, reminder: reminder, note: note)
        
        persistenceService.save()
    }
    
    func deleteRoutineTask(routineTask: RoutineTask, from careRecipient: CareRecipient) {
        routineTaskService.deleteRoutineTask(routineTask: routineTask, from: careRecipient)
        
        persistenceService.save()
    }
    
    func fetchAllTemplateRoutineTasks(from careRecipient: CareRecipient) -> [RoutineTask]{
        return routineTaskService.fetchRoutineTasks(for: careRecipient)
    }
    
    func fetchAllInstanceRoutineTasks(from careRecipient: CareRecipient) -> [TaskInstance]{
        return routineTaskService.fetchInstanceRoutineTasks(for: careRecipient)
    }
    
    func toggleInstanceIsDone(_ instance: TaskInstance) {
        routineTaskService.toggleInstanceIsDone(instance)
        
        persistenceService.save()
    }
    
    func addInstanceRoutineTask(from template: RoutineTask, on date: Date) {
        routineTaskService.addInstanceRoutineTask(from: template, on: date)
        
        persistenceService.save()
    }
    
    func deleteInstanceRoutineTask(_ instance: TaskInstance) {
        routineTaskService.deleteInstanceRoutineTask(instance)
        print("Deleting instance at time: \(instance.time ?? .now)")
        persistenceService.save()
    }
    
    func generateInstancesForToday(for careRecipient: CareRecipient) {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date()) //midnight normalization
        let templates = fetchAllTemplateRoutineTasks(from: careRecipient)
        
        
        for template in templates {
            // Count existing instances for this template today
            let existingCount = fetchAllInstanceRoutineTasks(from: careRecipient)
                .filter { $0.template == template && calendar.isDate($0.time!, inSameDayAs: today) }
                .count
            
            if isTaskActiveOnDay(template, day: today) {
                syncInstancesForTemplate(template, careRecipient: careRecipient, on: today)
            }
        }
        
        persistenceService.save()
    }
    
    
    //Helpers
    func isTaskActiveOnDay(_ task: RoutineTask, day: Date) -> Bool {
        let calendar = Calendar.current
        
        //check time interval
        guard let start = task.startDate, start <= day else { return false }
        if let end = task.endDate, end < day { return false }
        
        //check day of the week
        let todayWeek = Locale.Weekday.from(calendarWeekday: calendar.component(.weekday, from: day))
        guard let todayWeek, task.weekdays.contains(todayWeek) else { return false }
        
        return true
    }
    
    func convertDateToComponents(from date: Date, calendar: Calendar = .current) -> (Int, Int) {
        return (calendar.component(.hour, from: date), calendar.component(.minute, from: date))
    }
    
    func syncInstancesForTemplate(_ template: RoutineTask, careRecipient: CareRecipient, on day: Date) {
        let calendar = Calendar.current
        guard let allTimes = template.allTimes else { return }
        
        var templateTimes = allTimes.map { ($0.hour!, $0.minute!) }

        //fetch all instances for this task on the day
        var existingInstances = fetchAllInstanceRoutineTasks(from: careRecipient)
            .filter { instance in
                instance.template == template && calendar.isDate(instance.time!, inSameDayAs: day)
            }
        
        
        var existingTimes = existingInstances.map { convertDateToComponents(from: $0.time!) }
        
        //add new instances
        for time in templateTimes {
            if !existingTimes.contains(where: { $0 == time }) {
                guard let instanceTime = calendar.date(bySettingHour: time.0, minute: time.1, second: 0, of: day) else { continue }
                addInstanceRoutineTask(from: template, on: instanceTime)
                existingTimes.append(time)
            }
        }
        
        //delete obsolete instances, in case of editing
        for instance in existingInstances {
            let instanceTime = convertDateToComponents(from: instance.time!)
            print("Checking instance: \(instanceTime)")
            print("Template times:", templateTimes)
            
            
            if !templateTimes.contains(where: { $0 == instanceTime}) {
                deleteInstanceRoutineTask(instance)
                print("❌ Deleted obsolete instance at \(instanceTime)")
            }
        }
    }
    
    
    
    //    // MARK: - MEDICATION ACTIONS
    func addMedication(name: String, quantity: Double, unit: String, time: Date, frequency: FrequencyEnum, reminder: Bool, note: String, doctor: String, photo: Data, dose: String, in careRecipient: CareRecipient) {
        medicationService.addMedication(name: name, quantity: quantity, unit: unit, time: time, frequency: frequency, reminder: reminder, note: note, doctor: doctor, photo: photo, dose: dose, in: careRecipient)
        
        persistenceService.save()
    }
    
    func deleteMedication(medication: Medication, from careRecipient: CareRecipient) {
        medicationService.deleteMedication(medication: medication, from: careRecipient)
        
        persistenceService.save()
    }
    
    // MARK: - MEASUREMENT ACTIONS
    func addMeasurement(name: String, unit: String, value: Double, time: Date, frequency: FrequencyEnum, reminder: Bool, status: StatusEnum, in careRecipient: CareRecipient) {
        measurementService.addMeasurement(name: name, unit: unit, value: value, time: time, frequency: frequency, reminder: reminder, status: status, in: careRecipient)
        
        persistenceService.save()
    }
    
    func deleteMeasurement(measurement: Measurements, from careRecipient: CareRecipient) {
        measurementService.deleteMeasurement(measurement: measurement, from: careRecipient)
        
        persistenceService.save()
    }
    
}
