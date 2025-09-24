//
//  MentalState.swift
//  Altroo
//
//  Created by Layza Maria Rodrigues Carneiro on 24/09/25.
//

import Foundation

// MARK: MentalState -
enum EmotionalStateEnum: String {
    case depressed
    case aggressive
    case agitated
    case lively
    case calm
    case anxious
}

enum MemoryEnum: String {
    case intact
    case frequentForgetfulness
    case totalForgetfulness
}

enum OrientationEnum: String {
    case oriented
    case disorientedInSpace
    case disorientedInTime
    case disorientedInPersons
    case disorientedInAll
}

enum CognitionEnum: String {
    case lowCapacity
    case mediumCapacity
    case highCapacity
}
