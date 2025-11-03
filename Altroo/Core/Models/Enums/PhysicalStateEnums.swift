//
//  PhysicalStateEnums.swift
//  Altroo
//
//  Created by Layza Maria Rodrigues Carneiro on 24/09/25.
//
import Foundation

enum VisionEnum: String, CaseIterable {
    case noChanges
    case usesGlasses
    case usesLenses
    case lowVision
    case blind

    var displayText: String {
        switch self {
        case .noChanges:   return "Sem alterações"
        case .usesGlasses: return "Uso de óculos"
        case .usesLenses:  return "Uso de lentes"
        case .lowVision:   return "Baixa visão"
        case .blind:       return "Cego(a)"
        }
    }
}

enum HearingEnum: String, CaseIterable {
    case withoutDeficit
    case withDeficit

    var displayText: String {
        switch self {
        case .withoutDeficit: return "Sem déficit"
        case .withDeficit:    return "Com déficit"
        }
    }
}

enum MobilityEnum: String, CaseIterable {
    case noAssistance
    case withAssistance
    case bedridden

    var displayText: String {
        switch self {
        case .noAssistance:   return "Sem auxílio"
        case .withAssistance: return "Com auxílio"
        case .bedridden:      return "Restrito a cama"
        }
    }
}

enum OralHealthEnum: String, CaseIterable {
    case allTeethPresent
    case someTeethMissing
    case edentulous
    case usesDentures
    case usesBraces

    var displayText: String {
        switch self {
        case .allTeethPresent:  return "Possui todos os dentes"
        case .someTeethMissing: return "Possui dentes faltando"
        case .edentulous:       return "Sem dentes"
        case .usesDentures:     return "Usa dentadura"
        case .usesBraces:       return "Usa aparelho ortodôntico"
        }
    }
}
