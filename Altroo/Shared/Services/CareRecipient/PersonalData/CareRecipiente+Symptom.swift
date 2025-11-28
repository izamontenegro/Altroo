//
//  CareRecipiente+Symptom.swift
//  Altroo
//
//  Created by Layza Maria Rodrigues Carneiro on 06/10/25.
//

import Foundation

protocol SymptomProtocol {
    func addSymptom(name: String, symptomDescription: String, date: Date, author: String, in careRecipient: CareRecipient) -> Symptom?
    func editSymptom(symptom: Symptom, name: String, symptomDescription: String, date: Date)
    func deleteSymptom(symptomRecord: Symptom, from careRecipient: CareRecipient)
    func fetchAllSymptoms(from careRecipient: CareRecipient) -> [Symptom]
    func fetchAllSymptomForDate(_ date: Date, from careRecipient: CareRecipient) -> [Symptom]
}

extension CareRecipientFacade: SymptomProtocol {
    @discardableResult
    func addSymptom(name: String, symptomDescription: String, date: Date, author: String, in careRecipient: CareRecipient) -> Symptom? {
        
        guard let context = careRecipient.managedObjectContext else { return nil }
        
        let newSymptom = Symptom(context: context)
        newSymptom.name = name
        newSymptom.symptomDescription = symptomDescription
        newSymptom.date = date
        newSymptom.author = author
        
        let symptoms = careRecipient.mutableSetValue(forKey: "symptoms")
        symptoms.add(newSymptom)
        
        persistenceService.save()
        
        return newSymptom
    }
    
    func editSymptom(symptom: Symptom, name: String, symptomDescription: String, date: Date) {
        symptom.name = name
        symptom.symptomDescription = symptomDescription
        symptom.date = date
        
        persistenceService.save()
    }
    
    func deleteSymptom(symptomRecord: Symptom, from careRecipient: CareRecipient) {
        let symptoms = careRecipient.mutableSetValue(forKey: "symptoms")
        symptoms.remove(symptomRecord)
        
        persistenceService.save()
    }
    
    func fetchAllSymptoms(from careRecipient: CareRecipient) -> [Symptom] {
        if let symptoms = careRecipient.mutableSetValue(forKey: "symptoms") as? Set<Symptom> {
            return Array(symptoms)
        } else { return [] }
    }
    
    func fetchAllSymptomForDate(_ date: Date, from careRecipient: CareRecipient) -> [Symptom] {
        let calendar = Calendar.current
        
        if let symptoms = careRecipient.mutableSetValue(forKey: "symptoms") as? Set<Symptom> {
            let filtered = symptoms
                .filter {
                guard let symptomDate = $0.date else { return false }
                return calendar.isDate(symptomDate, inSameDayAs: date)
            }
                .sorted { ($0.date ?? Date.distantPast) < ($1.date ?? Date.distantPast) }
            return Array(filtered)
        } else { return [] }
    }
    
}
