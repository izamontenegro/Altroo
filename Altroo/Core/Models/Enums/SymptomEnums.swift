//
//  SymptomEnums.swift
//  Altroo
//
//  Created by Raissa Parente on 24/11/25.
//

import Foundation

enum SymptomCategory: CaseIterable {
    case general
    case physicalAndAccident
    case instestinal
    case neurological
    
    var displayText: String {
        switch self {
        case .general:
            "Geral"
        case .physicalAndAccident:
            "Física e Acidentes"
        case .instestinal:
            "Gastrointestinais"
        case .neurological:
            "Neurológicas e Equilíbrio"
        }
    }
    
    var symptoms: [SymptomExample] {
        SymptomExample.allCases.filter { $0.category == self }
    }
}


enum SymptomExample: CaseIterable {
    case moodChanges
    case shaking
    case allergy
    case fever

    case fall
    case fainting
    case trauma
    case wound

    case vomit
    case nausea
    case diarrhea
    case abdominalPain

    case convulsion
    case dizziness
    case vertigo
    case headache
    case desorientation
    
    var category: SymptomCategory {
        switch self {
        case .moodChanges, .shaking, .allergy, .fever:
            return .general

        case .fall, .fainting, .trauma, .wound:
            return .physicalAndAccident

        case .vomit, .nausea, .diarrhea, .abdominalPain:
            return .instestinal

        case .convulsion, .dizziness, .vertigo, .headache, .desorientation:
            return .neurological
        }
    }
    
    var displayText: String {
        switch self {
        case .moodChanges: "mood_changes".localized
        case .shaking: "shaking".localized
        case .allergy: "alergy".localized
        case .fever: "fever".localized

        case .fall: "fall".localized
        case .fainting: "fainting".localized
        case .trauma: "trauma".localized
        case .wound: "wound".localized

        case .vomit: "vomit".localized
        case .nausea: "nausea".localized
        case .diarrhea: "diarrhea".localized
        case .abdominalPain: "abdominal_pain".localized

        case .convulsion: "convulsion".localized
        case .dizziness: "dizziness".localized
        case .vertigo: "vertigo".localized
        case .headache: "headache".localized
        case .desorientation: "desorientation".localized
        }
    }

}
