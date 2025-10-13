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
    func addRoutineTask(name: String, period: PeriodEnum, time: Date, frequency: FrequencyEnum, reminder: Bool, note: String, in careRecipient: CareRecipient) {
        routineTaskService.addRoutineTask(name: name, period: period, time: time, frequency: frequency, reminder: reminder, note: note, in: careRecipient)
        
        persistenceService.save()
    }

    func deleteRoutineTask(routineTask: RoutineTask, from careRecipient: CareRecipient) {
        routineTaskService.deleteRoutineTask(routineTask: routineTask, from: careRecipient)
        
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
