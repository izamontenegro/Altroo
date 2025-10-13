//
//  DiseaseService.swift
//  Altroo
//
//  Created by Layza Maria Rodrigues Carneiro on 02/10/25.
//

import Foundation

protocol DiseaseServiceProtocol {
    func addDisease(name: String, in careRecipient: CareRecipient)
    
    func deleteDisease(disease: Disease, from careRecipient: CareRecipient)
}

class DiseaseService: DiseaseServiceProtocol {
    func addDisease(name: String, in careRecipient: CareRecipient) {
        
        guard let context = careRecipient.managedObjectContext else { return }
        let newDisease = Disease(context: context)
        
        newDisease.name = name
        
        if let healthProblems = careRecipient.healthProblems {
            let mutableDisease = healthProblems.mutableSetValue(forKey: "disease")
            mutableDisease.add(newDisease)
        }
    }
    
    func deleteDisease(disease: Disease, from careRecipient: CareRecipient) {
        if let healthProblems = careRecipient.healthProblems {
            let mutableDisease = healthProblems.mutableSetValue(forKey: "disease")
            mutableDisease.remove(disease)
        }
    }
}
