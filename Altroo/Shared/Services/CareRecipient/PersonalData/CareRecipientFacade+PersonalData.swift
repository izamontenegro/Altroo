//
//  PersonalDataService.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 29/09/25.
//

import Foundation

protocol PersonalDataServiceProtocol {
    func addAddress(address: String, in personalData: PersonalData)
    func addDateOfBirth(birthDate: Date, in personalData: PersonalData)
    func addGender(gender: String, in personalData: PersonalData)
    func addHeight(height: Double, in personalData: PersonalData)
    func addName(name: String, in personalData: PersonalData)
    func addWeight(weight: Double, in personalData: PersonalData)
}

extension CareRecipientFacade: PersonalDataServiceProtocol {
    
    func addAddress(address: String, in personalData: PersonalData) {
        personalData.address = address
        
        persistenceService.saveContext()
    }
    
    func addDateOfBirth(birthDate: Date, in personalData: PersonalData) {
        personalData.dateOfBirth = birthDate
        
        persistenceService.saveContext()
    }
    
    func addGender(gender: String, in personalData: PersonalData) {
        personalData.gender = gender
        
        persistenceService.saveContext()
    }
    
    func addHeight(height: Double, in personalData: PersonalData) {
        personalData.height = height
        
        persistenceService.saveContext()
    }
    
    func addName(name: String, in personalData: PersonalData) {
        personalData.name = name
        
        persistenceService.saveContext()
    }
    
    func addWeight(weight: Double, in personalData: PersonalData) {
        personalData.weight = weight
        
        persistenceService.saveContext()
    }
}
