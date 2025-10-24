//
//  CareRecipientFacade+PersonalData.swift
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
        
        persistenceService.save()
    }
    
    func addDateOfBirth(birthDate: Date, in personalData: PersonalData) {
        personalData.dateOfBirth = birthDate
        
        persistenceService.save()
    }
    
    func addGender(gender: String, in personalData: PersonalData) {
        personalData.gender = gender
        
        persistenceService.save()
    }
    
    func addHeight(height: Double, in personalData: PersonalData) {
        personalData.height = height
        
        persistenceService.save()
    }
    
    func addName(name: String, in personalData: PersonalData) {
        personalData.name = name
        
        persistenceService.save()
    }
    
    func addWeight(weight: Double, in personalData: PersonalData) {
        personalData.weight = weight
        
        persistenceService.save()
    }
}
