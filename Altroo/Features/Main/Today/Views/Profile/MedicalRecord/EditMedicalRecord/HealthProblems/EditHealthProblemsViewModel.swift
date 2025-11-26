//
//  DiseaseFormState.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 24/11/25.
//

import Foundation
import CoreData

struct DiseaseFormState: Equatable {
    var diseasesText: String = ""
}

struct HealthProblemsFormState: Equatable {
    var allergiesText: String = ""
    var observationText: String = ""
    var surgeryName: String = ""
    var surgeryDate: Date = Date()
}

final class EditHealthProblemsViewModel {

    private let userService: UserServiceProtocol
    private let careRecipientFacade: CareRecipientFacade

    var healthFormState = HealthProblemsFormState()
    var diseaseFormState = DiseaseFormState()

    init(userService: UserServiceProtocol, careRecipientFacade: CareRecipientFacade) {
        self.userService = userService
        self.careRecipientFacade = careRecipientFacade
    }

    func currentPatient() -> CareRecipient? {
        userService.fetchCurrentPatient()
    }

    func loadAllInitialStates() {
        loadInitialHealthProblemsFormState()
        loadInitialDiseaseFormState()
    }

    func loadInitialHealthProblemsFormState() {
        guard let patient = currentPatient(),
              let healthProblems = patient.healthProblems else {
            healthFormState = .init()
            return
        }

        var draft = HealthProblemsFormState()
        draft.allergiesText = healthProblems.allergies ?? ""
        draft.observationText = healthProblems.observation ?? ""
        draft.surgeryDate = Date()
        healthFormState = draft
    }

    func loadInitialDiseaseFormState() {
        guard let patient = currentPatient(),
              let healthProblems = patient.healthProblems,
              let diseasesSet = healthProblems.diseases as? Set<Disease> else {
            diseaseFormState = DiseaseFormState(diseasesText: "")
            return
        }

        let names = diseasesSet
            .compactMap { $0.name }
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
            .sorted { $0.localizedCaseInsensitiveCompare($1) == .orderedAscending }

        diseaseFormState = DiseaseFormState(diseasesText: names.joined(separator: ", "))
    }

    func updateDiseasesText(_ value: String) {
        var draft = diseaseFormState
        draft.diseasesText = value
        diseaseFormState = draft
    }

    func updateAllergiesText(_ value: String) {
        var draft = healthFormState
        draft.allergiesText = value
        healthFormState = draft
    }

    func updateObservationText(_ value: String) {
        var draft = healthFormState
        draft.observationText = value
        healthFormState = draft
    }

    func updateSurgeryName(_ value: String) {
        var draft = healthFormState
        draft.surgeryName = value
        healthFormState = draft
    }

    func updateSurgeryDate(_ value: Date) {
        var draft = healthFormState
        draft.surgeryDate = value
        healthFormState = draft
    }

    func normalizedDiseasesText(from rawText: String) -> String {
        let tokens = rawText
            .split(separator: ",")
            .map { String($0).trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }

        var seen = Set<String>()
        var uniquePreservingCasing: [String] = []
        for t in tokens {
            let key = t
                .folding(options: .diacriticInsensitive, locale: .current)
                .lowercased()
            if !seen.contains(key) {
                seen.insert(key)
                uniquePreservingCasing.append(t)
            }
        }

        let sorted = uniquePreservingCasing.sorted {
            $0.localizedCaseInsensitiveCompare($1) == .orderedAscending
        }
        return sorted.joined(separator: ", ")
    }

    private func parsedDiseases(from text: String) -> [String] {
        text
            .split(separator: ",")
            .map { String($0).trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
    }

    private func normalizeDiseaseKey(_ name: String?) -> String {
        (name ?? "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .folding(options: .diacriticInsensitive, locale: .current)
            .lowercased()
    }

    func persistDiseaseFormState() {
        guard let patient = currentPatient(),
              let healthProblems = patient.healthProblems else { return }

        let normalizedText = normalizedDiseasesText(from: diseaseFormState.diseasesText)
        diseaseFormState = DiseaseFormState(diseasesText: normalizedText)

        let targetNames = parsedDiseases(from: normalizedText)
        let targetKeys = Set(targetNames.map { normalizeDiseaseKey($0) })

        let existingSet = (healthProblems.diseases as? Set<Disease>) ?? []
        var existingByKey: [String: Disease] = [:]
        for disease in existingSet {
            existingByKey[normalizeDiseaseKey(disease.name)] = disease
        }

        for disease in existingSet {
            let key = normalizeDiseaseKey(disease.name)
            if !targetKeys.contains(key) {
                careRecipientFacade.deleteDisease(disease: disease, from: healthProblems)
            }
        }

        for name in targetNames {
            let key = normalizeDiseaseKey(name)
            if let existing = existingByKey[key] {
                if existing.name != name {
                    existing.name = name
                }
            } else {
                careRecipientFacade.addDisease(name: name, in: healthProblems)
            }
        }
        
        careRecipientFacade.updateMedicalRecord(careRecipient: patient)
        
        NotificationCenter.default.post(name: .medicalRecordDidChange, object: nil)
    }

    func removeDisease(_ disease: Disease) {
        guard let patient = currentPatient(),
              let healthProblems = patient.healthProblems else { return }
        careRecipientFacade.deleteDisease(disease: disease, from: healthProblems)
    }

    func persistAllergies() {
        guard let patient = currentPatient(),
              let healthProblems = patient.healthProblems else { return }
        careRecipientFacade.addAllergy(allergy: healthFormState.allergiesText, in: healthProblems)
    }

    func persistObservation() {
        guard let patient = currentPatient(),
              let healthProblems = patient.healthProblems else { return }
        careRecipientFacade.addObservation(observation: healthFormState.observationText, in: healthProblems)
    }

    func addSurgeryFromState() {
        guard let patient = currentPatient(),
              let healthProblems = patient.healthProblems else { return }
        let name = healthFormState.surgeryName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !name.isEmpty else { return }
        careRecipientFacade.addSurgery(
            name: name,
            date: healthFormState.surgeryDate,
            to: healthProblems
        )
        updateSurgeryName("")
    }

    func deleteSurgery(_ surgery: Surgery) {
        guard let patient = currentPatient(),
              let healthProblems = patient.healthProblems else { return }
        careRecipientFacade.deleteSurgery(surgery, from: healthProblems)
    }
}
