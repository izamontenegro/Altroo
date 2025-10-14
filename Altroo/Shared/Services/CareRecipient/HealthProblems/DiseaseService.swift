//
//  DiseaseService.swift
//  Altroo
//
//  Created by Layza Maria Rodrigues Carneiro on 02/10/25.
//

import Foundation

protocol DiseaseServiceProtocol {
    func addDisease(name: String, in healthProblems: HealthProblems)
    
    func deleteDisease(disease: Disease, from healthProblems: HealthProblems)
}

extension CareRecipientFacade: DiseaseServiceProtocol {
    func addDisease(name: String, in healthProblems: HealthProblems) {
        guard let context = healthProblems.managedObjectContext else { return }
        
        let newDisease = Disease(context: context)
        newDisease.name = name
        
        let mutableDiseases = healthProblems.mutableSetValue(forKey: "diseases")
        mutableDiseases.add(newDisease)
        
        persistenceService.save()
    }
    
    func deleteDisease(disease: Disease, from healthProblems: HealthProblems) {
        let mutableDiseases = healthProblems.mutableSetValue(forKey: "diseases")
        mutableDiseases.remove(disease)
        
        persistenceService.save()
    }
}
