//
//  EditMedicalRecordViewModel+HealthProblems.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 31/10/25.
//

// EditMedicalRecordViewModel+HealthProblems.swift
// EditMedicalRecordViewModel+HealthProblems.swift

import Foundation
import Combine
import CoreData

// Se já existir em outro arquivo, pode remover esta struct daqui.
struct HealthProblemsFormState: Equatable {
    var allergiesText: String = ""
    var observationText: String = ""
    var surgeryName: String = ""
    var surgeryDate: Date = Date()
}

extension EditMedicalRecordViewModel {

  
    // MARK: - Boot
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
        healthFormState.allergiesText = healthProblems.allergies ?? ""
        healthFormState.observationText = healthProblems.observation ?? ""
        healthFormState.surgeryDate = Date()
    }

    // Você já tinha este método; mantenha o seu se preferir.
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

    // MARK: - Updates de estado
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

    // MARK: - Doenças (normalização e persistência)
    func normalizedDiseasesText(from rawText: String) -> String {
        let tokens = rawText
            .split(separator: ",")
            .map { String($0).trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }

        var seen = Set<String>()
        var uniquePreservingCasing: [String] = []
        for t in tokens {
            let key = t.folding(options: .diacriticInsensitive, locale: .current).lowercased()
            if !seen.contains(key) {
                seen.insert(key)
                uniquePreservingCasing.append(t)
            }
        }

        let sorted = uniquePreservingCasing.sorted { $0.localizedCaseInsensitiveCompare($1) == .orderedAscending }
        return sorted.joined(separator: ", ")
    }

    private func parsedDiseases(from text: String) -> [String] {
        text
            .split(separator: ",")
            .map { String($0).trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
    }

    func persistDiseaseFormState() {
        guard let patient = currentPatient(),
              let healthProblems = patient.healthProblems else { return }

        let normalized = normalizedDiseasesText(from: diseaseFormState.diseasesText)
        diseaseFormState.diseasesText = normalized

        let names = parsedDiseases(from: normalized)
        for name in names {
            careRecipientFacade.addDisease(name: name, in: healthProblems)
        }
    }

    func removeDisease(_ disease: Disease) {
        guard let patient = currentPatient(),
              let healthProblems = patient.healthProblems else { return }
        careRecipientFacade.deleteDisease(disease: disease, from: healthProblems)
    }

    // MARK: - Alergias e Observações
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

    // MARK: - Cirurgias
    func addSurgeryFromState() {
        guard let patient = currentPatient(),
              let healthProblems = patient.healthProblems else { return }
        let name = healthFormState.surgeryName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !name.isEmpty else { return }
        careRecipientFacade.addSurgery(name: name, date: healthFormState.surgeryDate, to: healthProblems)
        updateSurgeryName("")
    }

    func deleteSurgery(_ surgery: Surgery) {
        guard let patient = currentPatient(),
              let healthProblems = patient.healthProblems else { return }
        careRecipientFacade.deleteSurgery(surgery, from: healthProblems)
    }
}
