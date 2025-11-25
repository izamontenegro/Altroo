//
//  EditMedicalRecordViewModel+PersonalData.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 31/10/25.
//

import Foundation
import CoreData
import CloudKit

struct PersonalDataFormState {
    var name: String = ""
    var address: String = ""
    var gender: String = ""
    var height: Double? = nil
    var weight: Double? = nil
    var dateOfBirth: Date? = nil
    var emergencyContact: ContactDraft? = nil
    var contactsText: String = ""
    
    var ageText: String {
        guard let dateOfBirth else { return "" }
        let years = Calendar.current.dateComponents([.year], from: dateOfBirth, to: Date()).year ?? 0
        return "\(years) anos"
    }
}

final class EditPersonalDataViewModel {
    
    private let userService: UserServiceProtocol
    private let careRecipientFacade: CareRecipientFacade
    private let validator: FormValidator
    
    var personalDataFormState = PersonalDataFormState()
    var fieldErrors: [String: String] = [:]
    
    init(
        userService: UserServiceProtocol,
        careRecipientFacade: CareRecipientFacade,
        validator: FormValidator = FormValidator()
    ) {
        self.userService = userService
        self.careRecipientFacade = careRecipientFacade
        self.validator = validator
    }
    
    func currentPatient() -> CareRecipient? {
        userService.fetchCurrentPatient()
    }
    
    func loadInitialPersonalData() {
        guard let patient = currentPatient(),
              let personalData = patient.personalData else {
            personalDataFormState = PersonalDataFormState()
            return
        }
        
        let contactsSet = personalData.contacts as? Set<Contact>
        let orderedContacts = contactsSet?.sorted { ($0.name ?? "") < ($1.name ?? "") } ?? []
        let firstContact = orderedContacts.first
        
        let emergencyContactDraft = firstContact.map {
            ContactDraft(
                name: $0.name ?? "",
                relationship: $0.relationship,
                phone: $0.phone
            )
        }
        
        let contactsText = MedicalRecordFormatter.contactsList(from: contactsSet)
        
        personalDataFormState = PersonalDataFormState(
            name: personalData.name ?? "",
            address: personalData.address ?? "",
            gender: personalData.gender ?? "",
            height: personalData.height == 0 ? nil : personalData.height,
            weight: personalData.weight == 0 ? nil : personalData.weight,
            dateOfBirth: personalData.dateOfBirth,
            emergencyContact: emergencyContactDraft,
            contactsText: contactsText
        )
    }
    
    func updateName(_ value: String) {
        personalDataFormState.name = value
    }
    
    func updateAddress(_ value: String) {
        personalDataFormState.address = value
    }
    
    func updateGender(_ value: String) {
        personalDataFormState.gender = value
    }
    
    private func parseDecimal(_ text: String) -> Double? {
        let formatter = NumberFormatter()
        formatter.locale = .current
        formatter.numberStyle = .decimal
        formatter.usesGroupingSeparator = false
        return formatter.number(from: text)?.doubleValue
    }
    
    func updateWeight(from text: String) {
        personalDataFormState.weight = parseDecimal(text)
    }
    
    func updateHeight(from text: String) {
        personalDataFormState.height = parseDecimal(text)
    }
    
    func updateDateOfBirth(_ date: Date) {
        personalDataFormState.dateOfBirth = date
    }
    
    func updateContactName(_ value: String) {
        if personalDataFormState.emergencyContact == nil {
            personalDataFormState.emergencyContact = ContactDraft(name: "")
        }
        personalDataFormState.emergencyContact?.name = value
    }
    
    func updateContactPhone(_ value: String) {
        if personalDataFormState.emergencyContact == nil {
            personalDataFormState.emergencyContact = ContactDraft(name: "")
        }
        personalDataFormState.emergencyContact?.phone = value
    }
    
    func updateContactRelationship(_ value: String) {
        if personalDataFormState.emergencyContact == nil {
            personalDataFormState.emergencyContact = ContactDraft(name: "")
        }
        personalDataFormState.emergencyContact?.relationship = value
    }
    
    @discardableResult
    func validatePersonalData() -> Bool {
        var newErrors: [String: String] = [:]
        
        _ = validator.isEmpty(personalDataFormState.name, error: &newErrors["name"])
        
        if let weightValue = personalDataFormState.weight, !weightValue.isZero {
            _ = validator.invalidValue(
                value: Int(weightValue),
                minValue: 0,
                maxValue: 500,
                error: &newErrors["weight"]
            )
        }
        
        if let heightValue = personalDataFormState.height, !heightValue.isZero {
            let heightCentimeters = (heightValue < 10) ? Int((heightValue * 100).rounded()) : Int(heightValue.rounded())
            
            _ = validator.invalidValue(
                value: heightCentimeters,
                minValue: 30,
                maxValue: 260,
                error: &newErrors["height"]
            )
        }
        
        if let birthDate = personalDataFormState.dateOfBirth {
            _ = validator.checkAge(13, date: birthDate, error: &newErrors["age"])
        }
        
        if let contact = personalDataFormState.emergencyContact {
            let nameFilled = !contact.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            let phoneFilled = !((contact.phone ?? "").trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            let relationshipFilled = !((contact.relationship ?? "").trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            
            let anyFieldFilled = nameFilled || phoneFilled || relationshipFilled
            
            if anyFieldFilled {
                if !nameFilled {
                    newErrors["contact_name"] = "Informe o nome do contato."
                }
                if !phoneFilled {
                    newErrors["contact_phone"] = "Informe o telefone."
                }
                if !relationshipFilled {
                    newErrors["contact_relationship"] = "Selecione a relação."
                }
            }
        }
        
        fieldErrors = newErrors
        return newErrors.isEmpty
    }
    
    func persistPersonalData() {
        guard let patient = currentPatient(),
              let personalData = patient.personalData else { return }
        
        careRecipientFacade.addName(name: personalDataFormState.name, in: personalData)
        careRecipientFacade.addAddress(address: personalDataFormState.address, in: personalData)
        careRecipientFacade.addGender(gender: personalDataFormState.gender, in: personalData)
        
        if let birthDate = personalDataFormState.dateOfBirth {
            careRecipientFacade.addDateOfBirth(birthDate: birthDate, in: personalData)
        }
        
        if let heightValue = personalDataFormState.height {
            let heightInMeters = (heightValue < 10) ? heightValue : (heightValue / 100.0)
            careRecipientFacade.addHeight(height: heightInMeters, in: personalData)
        }
        
        if let weightValue = personalDataFormState.weight {
            careRecipientFacade.addWeight(weight: weightValue, in: personalData)
        }
        
        let existingContacts = (personalData.contacts as? Set<Contact>) ?? []
        let orderedContacts = existingContacts.sorted { ($0.name ?? "") < ($1.name ?? "") }
        let currentContact = orderedContacts.first
        
        if let draft = personalDataFormState.emergencyContact,
           !(draft.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
             && (draft.phone ?? "").trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
             && (draft.relationship ?? "").trimmingCharacters(in: .whitespacesAndNewlines).isEmpty) {
            
            if let contact = currentContact {
                contact.name = draft.name
                contact.phone = draft.phone
                contact.relationship = draft.relationship
            } else {
                careRecipientFacade.addContact(
                    name: draft.name,
                    relationship: draft.relationship,
                    phone: draft.phone,
                    in: personalData
                )
            }
            
            if orderedContacts.count > 1 {
                for extra in orderedContacts.dropFirst() {
                    if let context = extra.managedObjectContext {
                        context.delete(extra)
                    }
                }
            }
        } else {
            for contact in existingContacts {
                if let context = contact.managedObjectContext {
                    context.delete(contact)
                }
            }
        }
        
        careRecipientFacade.updateMedicalRecord(careRecipient: patient)

    }
}
