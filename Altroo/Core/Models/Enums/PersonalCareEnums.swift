//
//  PersonalCareEnums.swift
//  Altroo
//
//  Created by Layza Maria Rodrigues Carneiro on 24/09/25.
//

import Foundation

// MARK: PersonalCare -
enum BathEnum: String, CaseIterable {
    case withoutAssistance
    case withAssistance

    var displayText: String {
        switch self {
        case .withoutAssistance: return "Sem auxílio"
        case .withAssistance:    return "Com auxílio"
        }
    }
}

enum HygieneEnum: String, CaseIterable {
    case withoutAssistance
    case withAssistance

    var displayText: String {
        switch self {
        case .withoutAssistance: return "Sem auxílio"
        case .withAssistance:    return "Com auxílio"
        }
    }
}

enum ExcretionEnum: String, CaseIterable {
    case normal
    case usesDiaper
    case usesEquipment

    var displayText: String {
        switch self {
        case .normal:         return "Normal"
        case .usesDiaper:     return "Usa fralda"
        case .usesEquipment:  return "Usa equipamentos"
        }
    }
}

enum FeedingEnum: String, CaseIterable {
    case solids
    case soft
    case liquids

    var displayText: String {
        switch self {
        case .solids:  return "Sólidos"
        case .soft:    return "Pastosos"
        case .liquids: return "Líquidos"
        }
    }
}
