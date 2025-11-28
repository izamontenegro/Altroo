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
    case needsHelp, bedridden
    
    var iconName: String {
        switch self {
        case .needsHelp:
            return "figure.2.arms.open"
        case .bedridden:
            return "bed.double.fill"
        }
    }
}
