//
//  PersonalDataService.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 29/09/25.
//

import Foundation

protocol PersonalDataServiceProtocol {
    func addAddress(address: String, in careRecipient: CareRecipient)
    func addDateOfBirth(birthDate: Date, in careRecipient: CareRecipient)
    func addGender(gender: String, in careRecipient: CareRecipient)
    func addHeight(height: Double, in careRecipient: CareRecipient)
    func addName(name: String, in careRecipient: CareRecipient)
    func addWeight(weight: Double, in careRecipient: CareRecipient)
}

extension PatientFacade: PersonalDataServiceProtocol {
    func addAddress(address: String, in careRecipient: CareRecipient) {
        
    }
    
    func addDateOfBirth(birthDate: Date, in careRecipient: CareRecipient) {
        
    }
    
    func addGender(gender: String, in careRecipient: CareRecipient) {
        
    }
    
    func addHeight(height: Double, in careRecipient: CareRecipient) {
        
    }
    
    func addName(name: String, in careRecipient: CareRecipient) {
        
    }
    
    func addWeight(weight: Double, in careRecipient: CareRecipient) {
        
    }
}
