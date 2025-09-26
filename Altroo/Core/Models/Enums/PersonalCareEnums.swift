//
//  PersonalCareEnums.swift
//  Altroo
//
//  Created by Layza Maria Rodrigues Carneiro on 24/09/25.
//

import Foundation

// MARK: PersonalCare -
enum BathEnum: String {
    case independent
    case partiallyAssisted
    case completelyAssisted
}

enum HygieneEnum: String {
    case independent
    case partiallyDependent
    case completelyDependent
}

enum ExcretionEnum: String {
    case independent
    case partiallyDependent
    case completelyDependent
}

enum FeedingEnum: String {
    case normal
    case softFoods
    case liquids
}

enum EquipmentEnum: String {
    case probe
    case colostomyBag
    case serum
    case pacemaker
    case pumps
    case none
}
