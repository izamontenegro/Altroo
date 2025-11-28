//
//  GeneralEnums.swift
//  Altroo
//
//  Created by Layza Maria Rodrigues Carneiro on 24/09/25.
//

import Foundation

enum CategoryEventEnum: String {
    case appointment
    case exam
    case procedure
    case hospitalization
    case illness
    case other
}

enum BehaviorEnum: String {
    case calm
    case agitated
    case cooperative
}

enum HistoryActivityType: String {
    case urine
    case stool
    case task
    case symptom
    case hydration
    case meal
    
    var displayText: String {
        switch self {
        case .urine:
            return "urine".localized
        case .stool:
            return "stool".localized
        case .task:
            return "task".localized
        case .symptom:
            return "Intercorrência"
        case .hydration:
            return "hydration".localized
        case .meal:
            return "feeding".localized
        }
    }
}

enum RelationshipOptionsEnum: String, CaseIterable {
    case caregiver = "Caregiver"
    case parent = "Parent"
    case child = "Child"
    case grandchild = "Grandchild"
    case greatGrandchild = "GreatGrandchild"
    case family = "Family"
    case friend = "Friend"
    case other = "Other"
    
    var displayText: String {
        switch self {
        case .caregiver: return "caregiver".localized
        case .parent: return "parent".localized
        case .child: return "child".localized
        case .grandchild: return "grandchild".localized
        case .greatGrandchild: return "greatGrandchild".localized
        case .family: return "family".localized
        case .friend: return "friend".localized
        case .other: return "other".localized
        }
    }
}
