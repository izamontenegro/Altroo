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
    
    // MARK: - Load inicial
    
    func loadInitialPersonalData() {
        guard let patient = currentPatient(),
              let personalData = patient.personalData else {
            personalDataFormState = PersonalDataFormState()
            return
        }
        
        let contactsSet = personalData.contacts as? Set<Contact>
        let orderedContacts = contactsSet?.sorted { ($0.name ?? "") < ($1.name ?? "") } ?? []
        let firstContact = orderedContacts.first
        
        let emergency = firstContact.map {
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
            emergencyContact: emergency,
            contactsText: contactsText
        )
    }
    
    // MARK: - Updates
    
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
        let f = NumberFormatter()
        f.locale = .current
        f.numberStyle = .decimal
        f.usesGroupingSeparator = false
        return f.number(from: text)?.doubleValue
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
    
    // MARK: - Validação
    
    @discardableResult
    func validatePersonalData() -> Bool {
        var newErrors: [String: String] = [:]
        
        _ = validator.isEmpty(personalDataFormState.name, error: &newErrors["name"])
        
        if let weight = personalDataFormState.weight, !weight.isZero {
            _ = validator.invalidValue(
                value: Int(weight),
                minValue: 0,
                maxValue: 500,
                error: &newErrors["weight"]
            )
        }
        
        if let h = personalDataFormState.height, !h.isZero {
            let hCm = (h < 10) ? Int((h * 100).rounded()) : Int(h.rounded())
            _ = validator.invalidValue(
                value: hCm,
                minValue: 30,
                maxValue: 260,
                error: &newErrors["height"]
            )
        }
        
        if let dateOfBirth = personalDataFormState.dateOfBirth {
            _ = validator.checkAge(13, date: dateOfBirth, error: &newErrors["age"])
        }
        
        if let contact = personalDataFormState.emergencyContact {
            let anyFilled =
                !contact.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                || !((contact.phone ?? "").trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                || !((contact.relationship ?? "").trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            
            if anyFilled {
                if contact.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    newErrors["contact_name"] = "Informe o nome do contato."
                }
                if (contact.phone ?? "").trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    newErrors["contact_phone"] = "Informe o telefone."
                }
                if (contact.relationship ?? "").trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    newErrors["contact_relationship"] = "Selecione a relação."
                }
            }
        }
        
        fieldErrors = newErrors
        return newErrors.isEmpty
    }
    
    // MARK: - Persistência
    
    func persistPersonalData() {
        guard let patient = currentPatient(),
              let personalData = patient.personalData else { return }
        
        careRecipientFacade.addName(name: personalDataFormState.name, in: personalData)
        careRecipientFacade.addAddress(address: personalDataFormState.address, in: personalData)
        careRecipientFacade.addGender(gender: personalDataFormState.gender, in: personalData)
        
        if let birth = personalDataFormState.dateOfBirth {
            careRecipientFacade.addDateOfBirth(birthDate: birth, in: personalData)
        }
        
        if let h = personalDataFormState.height {
            let meters = (h < 10) ? h : (h / 100.0)
            careRecipientFacade.addHeight(height: meters, in: personalData)
        }
        
        if let weight = personalDataFormState.weight {
            careRecipientFacade.addWeight(weight: weight, in: personalData)
        }
        
        let existingContacts = (personalData.contacts as? Set<Contact>) ?? []
        let orderedExisting = existingContacts.sorted { ($0.name ?? "") < ($1.name ?? "") }
        let currentSingle = orderedExisting.first
        
        if let draft = personalDataFormState.emergencyContact,
           !(draft.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
             && (draft.phone ?? "").trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
             && (draft.relationship ?? "").trimmingCharacters(in: .whitespacesAndNewlines).isEmpty) {
            
            if let contact = currentSingle {
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
            
            if orderedExisting.count > 1 {
                for extra in orderedExisting.dropFirst() {
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
    }
}
