//
//  MeasurementService.swift
//  Altroo
//
//  Created by Layza Maria Rodrigues Carneiro on 02/10/25.
//

import Foundation

protocol MeasurementServiceProtocol {
    
    func addMeasurement(name: String, unit: String, value: Double, time: Date, frequency: FrequencyEnum, reminder: Bool, status: StatusEnum, in careRecipient: CareRecipient)
    
    func deleteMeasurement(measurement: Measurements, from careRecipient: CareRecipient)
    
}

class MeasurementService: MeasurementServiceProtocol {
    func addMeasurement(name: String, unit: String, value: Double, time: Date, frequency: FrequencyEnum, reminder: Bool, status: StatusEnum, in careRecipient: CareRecipient) {
        
        guard let context = careRecipient.managedObjectContext else { return }
        let newMeasurement = Measurements(context: context)
        
        newMeasurement.name = name
        newMeasurement.unit = unit
        newMeasurement.value = value
        newMeasurement.time = time
        newMeasurement.frequency = frequency.rawValue
        newMeasurement.reminder = reminder
        newMeasurement.status = status.rawValue
        
        if let routineActivities = careRecipient.routineActivities {
            let mutableMeasurement = routineActivities.mutableSetValue(forKey: "measurements")
            mutableMeasurement.add(newMeasurement)
        }
    }
    
    func deleteMeasurement(measurement: Measurements, from careRecipient: CareRecipient) {
        if let routineActivities = careRecipient.routineActivities {
            let mutableMeasurement = routineActivities.mutableSetValue(forKey: "measurements")
            mutableMeasurement.remove(measurement)
        }
    }
}
