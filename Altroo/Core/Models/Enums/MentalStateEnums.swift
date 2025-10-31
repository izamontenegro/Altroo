//
//  MentalState.swift
//  Altroo
//
//  Created by Layza Maria Rodrigues Carneiro on 24/09/25.
//

import Foundation

// MARK: MentalState -
import Foundation

enum EmotionalStateEnum: String, CaseIterable {
    case calm
    case depressed
    case agitated
    case aggressive
    case lively
    case anxious

    var displayText: String {
        switch self {
        case .calm:      return "Calmo"
        case .depressed: return "Depressivo"
        case .agitated:  return "Agitado"
        case .aggressive:return "Agressivo"
        case .lively:    return "Vívido"
        case .anxious:   return "Ansioso"
        }
    }
}

enum MemoryEnum: String, CaseIterable {
    case intact
    case impaired

    var displayText: String {
        switch self {
        case .intact:   return "Mantida"
        case .impaired: return "Prejudicada"
        }
    }
}

enum OrientationEnum: String, CaseIterable {
    case oriented
    case disorientedInTime
    case disorientedInSpace
    case disorientedInPersons
    case disorientedInAll

    var displayText: String {
        switch self {
        case .oriented:             return "Bem orientado"
        case .disorientedInTime:    return "Desorientado em tempo"
        case .disorientedInSpace:   return "Desorientado em espaço"
        case .disorientedInPersons: return "Desorientado em pessoas"
        case .disorientedInAll:     return "Desorientado em tudo"
        }
    }
}

enum CognitionEnum: String, CaseIterable {
    case lowCapacity
    case mediumCapacity
    case highCapacity

    var displayText: String {
        switch self {
        case .lowCapacity:    return "Baixa capacidade"
        case .mediumCapacity: return "Média capacidade"
        case .highCapacity:   return "Alta capacidade"
        }
    }
}
