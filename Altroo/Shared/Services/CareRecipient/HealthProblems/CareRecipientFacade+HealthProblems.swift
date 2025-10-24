//
//  CareRecipientFacade+HealthProblems.swift
//  Altroo
//
//  Created by Layza Maria Rodrigues Carneiro on 01/10/25.
//

import Foundation

protocol HealthProblemsServiceProtocol {
    func addSurgery(surgery: String, in healthProblem: HealthProblems)
    func addAllergy(allergy: String, in healthProblem: HealthProblems)
    func addObservation(observation: String, in healthProblem: HealthProblems)
    func addBedriddenInformation(bedriddenStatus: String, in healthProblem: HealthProblems)
}

extension CareRecipientFacade: HealthProblemsServiceProtocol {
    
    func addSurgery(surgery: String, in healthProblem: HealthProblems) {
        healthProblem.surgery?.append(surgery)
        
        persistenceService.save()
    }
    
    func addAllergy(allergy: String, in healthProblem: HealthProblems) {
        healthProblem.allergies?.append(allergy)
        
        persistenceService.save()
    }
    
    func addObservation(observation: String, in healthProblem: HealthProblems) {
        healthProblem.observation = observation
        
        persistenceService.save()
    }
    
    func addBedriddenInformation(bedriddenStatus: String, in healthProblem: HealthProblems) {
        healthProblem.bedridden = bedriddenStatus
    }
    
}
