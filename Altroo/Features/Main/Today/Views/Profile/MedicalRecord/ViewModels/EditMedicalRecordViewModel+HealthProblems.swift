//
//  EditMedicalRecordViewModel+HealthProblems.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 31/10/25.
//

import Combine
import CloudKit
import CoreData

struct DiseaseFormState: Equatable {
    var diseasesText: String = ""
}

extension EditMedicalRecordViewModel {
    
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
        return text
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
}
