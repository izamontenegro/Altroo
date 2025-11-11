//
//  HealthProblemEnums.swift
//  Altroo
//
//  Created by Layza Maria Rodrigues Carneiro on 12/10/25.
//

import Foundation

enum BedriddenStatus: String {
    case notBedridden
    case bedriddenMovable
    case bedriddenImmobile
}

enum BedriddenState {
    case movement, noMovement
    
    var iconName: String {
        switch self {
        case .movement:
            return "bed.double.fill"
        case .noMovement:
            return "bed.double.fill"
        }
    }
    var iconCheck: String {
        switch self {
        case .movement:
            return "checkmark.circle.fill"
        case .noMovement:
            return "xmark.circle.fill"
        }
    }
}
