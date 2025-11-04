//
//  EditMedicalRecordViewModel+PersonalData.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 31/10/25.
//

import Combine
import CloudKit
import CoreData

struct PersonalDataFormState: Equatable {
    var name: String = ""
    var address: String = ""
    var gender: String = ""
    var height: Double? = nil
    var weight: Double? = nil
    var dateOfBirth: Date? = nil
    var contactsText: String = ""
    
    var ageText: String {
        guard let dateOfBirth else { return "" }
        let calendar = Calendar.current
        let years = calendar.dateComponents([.year], from: dateOfBirth, to: Date()).year ?? 0
        return "\(years) anos"
    }
}

extension EditMedicalRecordViewModel {
    
    func loadInitialPersonalDataFormState() {
        guard let patient = currentPatient(),
              let personalData = patient.personalData else {
            personalDataFormState = PersonalDataFormState()
            return
        }

        let contactsText = MedicalRecordFormatter.contactsList(from: personalData.contacts as? Set<Contact>)
        personalDataFormState = PersonalDataFormState(
            name: personalData.name ?? "",
            address: personalData.address ?? "",
            gender: personalData.gender ?? "",
            height: personalData.height == 0 ? nil : personalData.height,
            weight: personalData.weight == 0 ? nil : personalData.weight,
            dateOfBirth: personalData.dateOfBirth,
            contactsText: contactsText
        )
    }
    
    func updateName(_ value: String) {
        var draft = personalDataFormState
        draft.name = value
        personalDataFormState = draft
    }

    func updateAddress(_ value: String) {
        var draft = personalDataFormState
        draft.address = value
        personalDataFormState = draft
    }

    func updateGender(_ value: String) {
        var draft = personalDataFormState
        draft.gender = value
        personalDataFormState = draft
    }

    func updateHeight(from text: String) {
        var draft = personalDataFormState
        draft.height = Double(text.replacingOccurrences(of: ",", with: "."))
        personalDataFormState = draft
    }

    func updateWeight(from text: String) {
        var draft = personalDataFormState
        draft.weight = Double(text.replacingOccurrences(of: ",", with: "."))
        personalDataFormState = draft
    }

    func updateDateOfBirth(_ date: Date) {
        var draft = personalDataFormState
        draft.dateOfBirth = date
        personalDataFormState = draft
    }

    func persistPersonalDataFormState() {
        guard let patient = currentPatient(),
              let personalData = patient.personalData else { return }

        careRecipientFacade.addName(name: personalDataFormState.name, in: personalData)
        careRecipientFacade.addAddress(address: personalDataFormState.address, in: personalData)
        careRecipientFacade.addGender(gender: personalDataFormState.gender, in: personalData)

        if let birth = personalDataFormState.dateOfBirth {
            careRecipientFacade.addDateOfBirth(birthDate: birth, in: personalData)
        }
        if let height = personalDataFormState.height {
            careRecipientFacade.addHeight(height: height, in: personalData)
        }
        if let weight = personalDataFormState.weight {
            careRecipientFacade.addWeight(weight: weight, in: personalData)
        }
    }
}
