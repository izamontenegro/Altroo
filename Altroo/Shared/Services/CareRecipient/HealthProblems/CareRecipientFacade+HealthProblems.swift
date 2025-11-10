//
//  CareRecipientFacade+HealthProblems.swift
//  Altroo
//
//  Created by Layza Maria Rodrigues Carneiro on 01/10/25.
//
import Foundation
import CoreData

protocol HealthProblemsServiceProtocol {
    func addSurgery(name: String, date: Date, to healthProblem: HealthProblems)
    func deleteSurgery(_ surgery: Surgery, from healthProblem: HealthProblems)
    func addAllergy(allergy: String, in healthProblem: HealthProblems)
    func addObservation(observation: String, in healthProblem: HealthProblems)
    func addBedriddenInformation(bedriddenStatus: String, in healthProblem: HealthProblems)
}

extension CareRecipientFacade: HealthProblemsServiceProtocol {
    
    func addSurgery(name: String, date: Date, to healthProblem: HealthProblems) {
        let newSurgery = Surgery(context: persistenceService.stack.context)
        
        newSurgery.name = name
        newSurgery.date = date
        
        let mutableSurgeries = healthProblem.mutableSetValue(forKey: "surgeries")
        mutableSurgeries.add(newSurgery)
        
        persistenceService.save()
    }

    func deleteSurgery(_ surgery: Surgery, from healthProblem: HealthProblems) {
        let mutableSurgeries = healthProblem.mutableSetValue(forKey: "surgeries")
        mutableSurgeries.remove(surgery)
        persistenceService.save()

    }
    
    func addAllergy(allergy: String, in healthProblem: HealthProblems) {
        healthProblem.allergies = allergy
        persistenceService.save()
    }
    
    func addObservation(observation: String, in healthProblem: HealthProblems) {
        healthProblem.observation = observation
        persistenceService.save()
    }
    
    func addBedriddenInformation(bedriddenStatus: String, in healthProblem: HealthProblems) {
        healthProblem.bedridden = bedriddenStatus
        persistenceService.save()
    }
}
