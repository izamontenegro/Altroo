//
//  SymptomEnums.swift
//  Altroo
//
//  Created by Raissa Parente on 24/11/25.
//

enum SymptomTypes {
    case general
    case physicalAndAccident
    case instestinal
    case neurological
    
    var displayText: String {
        switch self {
        case .general: "Geral"
        case .physicalAndAccident: "Física e Acidentes"
        case .instestinal: "Gastrointestinais"
        case .neurological: "Neurológicas e Equilíbrio"
        }
    }
    
    var allTypes: [String] {
        switch self {
        case .general:
            ["mood_changes".localized, "shaking".localized, "alergy".localized, "fever".localized]
        case .physicalAndAccident:
            ["fall".localized, "fainting".localized, "trauma".localized, "wound".localized]
        case .instestinal:
            ["vomit".localized, "nausea".localized, "diarrhea".localized, "abdominal_pain".localized]
        case .neurological:
            ["convulsion".localized, "dizziness".localized, "vertigo".localized, "headache".localized, "desorientation".localized]
        }
    }
}




