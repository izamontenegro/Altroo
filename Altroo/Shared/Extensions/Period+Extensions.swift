//
//  Period+Extensions.swift
//  Altroo
//
//  Created by Raissa Parente on 23/11/25.
//

//EMPTY FOR RESOLVING CONFLICT
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
        case .overnight: return "overnight".localized
        case .morning:   return "morning".localized
        case .afternoon: return "afternoon".localized
        case .night:     return "night".localized
        }
    }

    var localizedCapitalized: String {
        return displayName.capitalized
    }
}
