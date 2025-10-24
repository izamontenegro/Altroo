//
//  PhysicalStateEnums.swift
//  Altroo
//
//  Created by Layza Maria Rodrigues Carneiro on 24/09/25.
//

import Foundation

// MARK: PhysicalState -
enum VisionEnum: String {
    case complete
    case partiallyImpaired
    case completelyImpaired
}

enum HearingEnum: String {
    case complete
    case partiallyImpaired
    case completelyImpaired
}

enum OralHealthEnum: String {
    case allTeethPresent
    case someTeethMissing
    case edentulous
    case usesProsthesis
}

enum MobilityEnum: String {
    case independent
    case equipmentAssisted
    case humanAssisted
    case bedriddenWithMovement
    case bedriddenWithoutMovement
}
