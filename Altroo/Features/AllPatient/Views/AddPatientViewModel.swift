//
//  AddPatientViewModel.swift
//  Altroo
//
//  Created by Layza Maria Rodrigues Carneiro on 12/10/25.
//

import Foundation
import Combine
import CoreData

final class AddPatientViewModel: ObservableObject {
    
    private let careRecipientFacade: CareRecipientFacade
    private let userService: UserServiceProtocol
    
    @Published var newPatient: CareRecipient?
    @Published var name: String = ""
    @Published var gender: String = ""
    @Published var dateOfBirth: Date = Date()
    @Published var height: Double = 0
    @Published var weight: Double = 0
    @Published var address: String = ""
    
    @Published var contacts: [ContactDraft] = []
    @Published var diseases: [DiseaseDraft] = []
    @Published var bedriddenStatus: BedriddenStatus = .notBedridden
    
    private var cancellables = Set<AnyCancellable>()
    
    init(careRecipientFacade: CareRecipientFacade, userService: UserServiceProtocol) {
        self.careRecipientFacade = careRecipientFacade
        self.userService = userService
    }

    func updatePersonalData(
        name: String,
        gender: String,
        dateOfBirth: Date,
        height: Double,
        weight: Double,
        address: String
    ) {
        self.name = name
        self.gender = gender
        self.dateOfBirth = dateOfBirth
        self.height = height
        self.weight = weight
        self.address = address
    }
    
    func addContact(name: String, contactDescription: String?, contactMethod: String?) {
        let contact = ContactDraft(name: name, description: contactDescription, method: contactMethod)
        contacts.append(contact)
    }
    
    func updateHealthProblems(diseases: [DiseaseDraft], bedriddenStatus: BedriddenStatus) {
        self.diseases = diseases
        self.bedriddenStatus = bedriddenStatus
    }
    
    func finalizeCareRecipient() {
        newPatient = careRecipientFacade.buildCareRecipient { pd, pc, hp, mental, physical, routine, basicNeeds, event, symptom in
            
            // Personal Data
            self.careRecipientFacade.addName(name: self.name, in: pd)
            self.careRecipientFacade.addGender(gender: self.gender, in: pd)
            self.careRecipientFacade.addDateOfBirth(birthDate: self.dateOfBirth, in: pd)
            self.careRecipientFacade.addHeight(height: self.height, in: pd)
            self.careRecipientFacade.addWeight(weight: self.weight, in: pd)
            self.careRecipientFacade.addAddress(address: self.address, in: pd)
            
            // Contacts
            for contact in self.contacts {
                self.careRecipientFacade.addContact(
                    name: contact.name,
                    contactDescription: contact.description,
                    contactMethod: contact.method,
                    in: pd
                )
            }
            
            // Health Problems
            for disease in self.diseases {
                self.careRecipientFacade.addDisease(name: disease.name, in: hp)
            }
            hp.bedridden = self.bedriddenStatus.rawValue
        }
        
        guard let newPatient else { return }
        userService.addPatient(newPatient)
        userService.setCurrentPatient(newPatient)
        
        contacts = []
        diseases = []
        bedriddenStatus = .notBedridden
    }
}

struct ContactDraft: Identifiable {
    let id = UUID()
    var name: String
    var description: String?
    var method: String?
}

struct DiseaseDraft: Identifiable {
    let id = UUID()
    var name: String
}
