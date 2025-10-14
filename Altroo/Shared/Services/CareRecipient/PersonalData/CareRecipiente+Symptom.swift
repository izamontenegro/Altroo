//
//  CareRecipiente+Symptom.swift
//  Altroo
//
//  Created by Layza Maria Rodrigues Carneiro on 06/10/25.
//

import Foundation

protocol SymptomProtocol {
    func addSymptom(name: String, symptomDescription: String, date: Date, in careRecipient: CareRecipient)
    func deleteSymptom(symptomRecord: Symptom, from careRecipient: CareRecipient)
}

extension CareRecipientFacade: SymptomProtocol {
    
    func addSymptom(name: String, symptomDescription: String, date: Date, in careRecipient: CareRecipient) {
        
        guard let context = careRecipient.managedObjectContext else { return }
        
        let newSymptom = Symptom(context: context)
        newSymptom.name = name
        newSymptom.symptomDescription = symptomDescription
        newSymptom.date = date
        
        let symptoms = careRecipient.mutableSetValue(forKey: "symptoms")
        symptoms.add(newSymptom)
    }
    
    func deleteSymptom(symptomRecord: Symptom, from careRecipient: CareRecipient) {
        let symptoms = careRecipient.mutableSetValue(forKey: "symptoms")
        symptoms.remove(symptomRecord)
    }

}
