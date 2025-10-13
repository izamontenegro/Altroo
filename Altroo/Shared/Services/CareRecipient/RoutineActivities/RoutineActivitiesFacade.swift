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
    
    func markInstanceAsDone(_ instance: TaskInstance) {
        routineTaskService.markInstanceAsDone(instance)
        
        persistenceService.save()
    }
    
    func addInstanceRoutineTask(from template: RoutineTask, on date: Date) {
        routineTaskService.addInstanceRoutineTask(from: template, on: date)
        
        persistenceService.save()
    }
    
    func deleteInstanceRoutineTask(_ instance: TaskInstance) {
        routineTaskService.deleteInstanceRoutineTask(instance)
        
        persistenceService.save()
    }
    
    func generateInstancesForToday(for careRecipient: CareRecipient) {
        let today = Date()
        let calendar = Calendar.current
        let todayWeek = Locale.Weekday.from(calendarWeekday: Calendar.current.component(.weekday, from: today))
        let templates = fetchAllTemplateRoutineTasks(from: careRecipient)
        print("Templates encontrados: \(templates.count)")
        
        for template in templates {
            guard let allTimes = template.allTimes else { continue }
            guard let todayWeek, template.weekdays.contains(todayWeek) else {
                print("Pulando template \(template.name ?? "") — não é hoje.")
                continue
            }
            
            for time in allTimes {
                let exists = fetchAllInstanceRoutineTasks(from: careRecipient)
                                .contains { instance in
                                    instance.template == template && calendar.isDate(instance.time!, inSameDayAs: today) &&
                                    calendar.component(.hour, from: instance.time!) == time.hour &&
                                    calendar.component(.minute, from: instance.time!) == time.minute
                                }
                
                if !exists {
                    print("Criando instância para \(template.name ?? "") às \(time)")
                    addInstanceRoutineTask(from: template, on: today)
                }
            }

            
        }
        persistenceService.save()
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
