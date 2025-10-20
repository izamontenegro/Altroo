//
//  PeriodExtensions.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 17/10/25.
//
import Foundation

extension PeriodEnum {
    static var current: PeriodEnum {
        let hour = Calendar.current.component(.hour, from: Date())

        switch hour {
        case 0..<6: return .overnight
        case 6..<12: return .morning
        case 12..<18: return .afternoon
        case 18..<24: return .night
        default: return .night
        }
    }

    var displayName: String {
        switch self {
        case .overnight: return "Madrugada"
        case .morning:   return "Manhã"
        case .afternoon: return "Tarde"
        case .night:     return "Noite"
        }
    }

    var localizedCapitalized: String {
        return displayName.capitalized
    }
}
