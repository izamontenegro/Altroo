//
//  MedicationService.swift
//  Altroo
//
//  Created by Layza Maria Rodrigues Carneiro on 02/10/25.
//

import Foundation

protocol MedicationServiceProtocol {
    
    func addMedication(name: String, quantity: Double, unit: String, time: Date, frequency: FrequencyEnum, reminder: Bool, note: String, doctor: String, photo: Data, dose: String, in careRecipient: CareRecipient)
    
    func deleteMedication(medication: Medication, from careRecipient: CareRecipient)
    
}

class MedicationService: MedicationServiceProtocol {
    func addMedication(name: String, quantity: Double, unit: String, time: Date, frequency: FrequencyEnum, reminder: Bool, note: String, doctor: String, photo: Data, dose: String, in careRecipient: CareRecipient) {
        
        guard let context = careRecipient.managedObjectContext else { return }
        let newMedication = Medication(context: context)
        
        newMedication.name = name
        newMedication.quantity = quantity
        newMedication.unit = unit
        newMedication.time = time
        newMedication.frequency = frequency.rawValue
        newMedication.reminder = reminder
        newMedication.note = note
        newMedication.doctor = doctor
        newMedication.photo = photo
//        newMedication.doses = dose
        
        if let routineActivities = careRecipient.routineActivities {
            let mutableMedication = routineActivities.mutableSetValue(forKey: "medication")
            mutableMedication.add(newMedication)
        }
    }
    
    func deleteMedication(medication: Medication, from careRecipient: CareRecipient) {
        if let routineActivities = careRecipient.routineActivities {
            let mutableMedication = routineActivities.mutableSetValue(forKey: "medication")
            mutableMedication.remove(medication)
        }
    }
}
