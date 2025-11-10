//
//  EditMedicalRecordViewModel+PersonalData.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 31/10/25.
//

import UIKit
import Combine
import CoreData
import CloudKit

struct PersonalDataFormState {
    var name: String = ""
    var address: String = ""
    var gender: String = ""
    var height: Double? = nil
    var weight: Double? = nil
    var dateOfBirth: Date? = nil

    // Novo: contato de emergência editável
    var emergencyContact: ContactDraft? = nil

    // Mantido caso alguma tela ainda use
    var contactsText: String = ""

    var ageText: String {
        guard let dateOfBirth else { return "" }
        let years = Calendar.current.dateComponents([.year], from: dateOfBirth, to: Date()).year ?? 0
        return "\(years) anos"
    }
}

// MARK: - EditMedicalRecordViewModel – Carregar/Atualizar/Validar/Persistir contato

extension EditMedicalRecordViewModel {

    // Carrega estado inicial com primeiro contato como "de emergência"
    func loadInitialPersonalDataFormState() {
        guard let patient = currentPatient(),
              let personalData = patient.personalData else {
            personalDataFormState = PersonalDataFormState()
            return
        }

        let contactsSet = personalData.contacts as? Set<Contact>
        let first = contactsSet?.first
        let emergency = first.map { c in
            ContactDraft(
                name: c.name ?? "",
                relationship: c.relationship,
                phone: c.phone
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

    // Atualizações básicas
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

    // Atualizações do contato de emergência
    func updateContactName(_ value: String) {
        var draft = personalDataFormState
        if draft.emergencyContact == nil { draft.emergencyContact = ContactDraft(name: "") }
        draft.emergencyContact?.name = value
        personalDataFormState = draft
    }

    func updateContactPhone(_ value: String) {
        var draft = personalDataFormState
        if draft.emergencyContact == nil { draft.emergencyContact = ContactDraft(name: "") }
        draft.emergencyContact?.phone = value
        personalDataFormState = draft
    }

    func updateContactRelationship(_ value: String) {
        var draft = personalDataFormState
        if draft.emergencyContact == nil { draft.emergencyContact = ContactDraft(name: "") }
        draft.emergencyContact?.relationship = value
        personalDataFormState = draft
    }

    // Validação incluindo contato
    func validatePersonalData() -> Bool {
        var newErrors: [String: String] = [:]

        _ = validator.isEmpty(personalDataFormState.name, error: &newErrors["name"])

        if let weight = personalDataFormState.weight, !weight.isZero {
            _ = validator.invalidValue(value: Int(weight), minValue: 0, maxValue: 999, error: &newErrors["weight"])
        }

        if let height = personalDataFormState.height, !height.isZero {
            _ = validator.invalidValue(value: Int(height), minValue: 9, maxValue: 999, error: &newErrors["height"])
        }

        if let dateOfBirth = personalDataFormState.dateOfBirth {
            _ = validator.checkAge(13, date: dateOfBirth, error: &newErrors["age"])
        }

        if let c = personalDataFormState.emergencyContact {
            let anyFilled = !(c.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                          || !((c.phone ?? "").trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                          || !((c.relationship ?? "").trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            if anyFilled {
                if c.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    newErrors["contact_name"] = "Informe o nome do contato."
                }
                if (c.phone ?? "").trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    newErrors["contact_phone"] = "Informe o telefone."
                }
                if (c.relationship ?? "").trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    newErrors["contact_relationship"] = "Selecione a relação."
                }
            }
        }

        fieldErrors = newErrors
        return newErrors.isEmpty
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

        // Persistir contato (simples: adiciona se houver nome)
        if let c = personalDataFormState.emergencyContact,
           !c.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            careRecipientFacade.addContact(
                name: c.name,
                relationship: c.relationship,
                phone: c.phone,
                in: personalData
            )
        }
    }
}
