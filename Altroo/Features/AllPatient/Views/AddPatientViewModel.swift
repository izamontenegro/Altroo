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
    
    @Published var contact: ContactDraft = ContactDraft(name: "")
    @Published var diseases: [DiseaseDraft] = []
    @Published var bedriddenStatus: BedriddenStatus = .notBedridden
    
    // TODO: REALLY UPDATE THE USERNAME HERE
    @Published var userName: String = "izaiza"
    @Published var userNameError: String?
    @Published var selectedUserRelationship: String = "Cuidador"
    @Published var selectedContactRelationship: String = "Filha/Filho"

    @Published var isAllDay = true
    
    @Published private(set) var fieldErrors: [String: String] = [:]
    private let validator = FormValidator()

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
    
    func updateContact(name: String, phone: String?) {
        contact.name = name
        contact.phone = phone
        contact.relationship = selectedContactRelationship
    }
    
    func updateHealthProblems(diseases: [DiseaseDraft], bedriddenStatus: BedriddenStatus) {
        self.diseases = diseases
        self.bedriddenStatus = bedriddenStatus
    }
    
    func finalizeCareRecipient() {        
        newPatient = careRecipientFacade.buildCareRecipient { personalData, personalCare, healthProblems, mental, physical, routine, basicNeeds, event in
            
            // Personal Data
            self.careRecipientFacade.addName(name: self.name, in: personalData)
            self.careRecipientFacade.addGender(gender: self.gender, in: personalData)
            self.careRecipientFacade.addDateOfBirth(birthDate: self.dateOfBirth, in: personalData)
            self.careRecipientFacade.addHeight(height: self.height, in: personalData)
            self.careRecipientFacade.addWeight(weight: self.weight, in: personalData)
            self.careRecipientFacade.addAddress(address: self.address, in: personalData)
            
            // Contacts
            if !contact.name.isEmpty {
                self.careRecipientFacade.addContact(
                    name: contact.name,
                    relationship: contact.relationship,
                    phone: contact.phone,
                    in: personalData
                )
            }
            
            // Health Problems
            for disease in self.diseases {
                self.careRecipientFacade.addDisease(name: disease.name, in: healthProblems)
            }
            healthProblems.bedridden = self.bedriddenStatus.rawValue
        }
        
        guard let newPatient else { return }
        userService.addPatient(newPatient)
        userService.setCurrentPatient(newPatient)
        
        guard let user = userService.fetchUser() else { return }
        careRecipientFacade.addCaregiver(newPatient, for: user)
                
        diseases = []
        bedriddenStatus = .notBedridden
    }
    
    func finalizeUser(startDate: Date, endDate: Date) {
        userService.setName(userName)
        print("nome na viewmodel: \(userName)")
        userService.setCategory(selectedUserRelationship)
        
        if isAllDay {
            userService.setShift([.afternoon, .overnight, .morning, .night])
        } else {
            let shift = PeriodEnum.shifts(for: startDate, end: endDate)
            userService.setShift(shift)
        }
    }
}

struct ContactDraft: Identifiable {
    let id = UUID()
    var name: String
    var relationship: String?
    var phone: String?
}

struct DiseaseDraft: Identifiable {
    let id = UUID()
    var name: String
}


//MARK: - VALIDATION
extension AddPatientViewModel {
    func validateProfile() -> Bool {
        var newErrors: [String: String] = [:]

        _ = validator.isEmpty(name, error: &newErrors["name"])
        
        if !weight.isZero {
            _ = validator.invalidValue(value: Int(weight), minValue: 0, maxValue: 999, error: &newErrors["weight"])
        }
        
        if !height.isZero {
            _ = validator.invalidValue(value: Int(height), minValue: 9, maxValue: 999, error: &newErrors["height"])
        }
        
        _ = validator.checkAge(13, date: dateOfBirth, error: &newErrors["age"])

        fieldErrors = newErrors

        return newErrors.isEmpty
    }
    
    func validateUser() -> Bool {
        guard validator.isEmpty(userName, error: &userNameError) else { return false }
        return true
    }
    
    func fetchUser() -> User?{
        return userService.fetchUser()
    }
}
