//
//  GeneralEnums.swift
//  Altroo
//
//  Created by Layza Maria Rodrigues Carneiro on 24/09/25.
//

import Foundation

// MARK: EventEnums -
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

enum FrequencyEnum: String {
    case daily
    case weekly
    case biweekly
    case monthly
}

enum StatusEnum: String {
    case beforeLunch
    case afterLunch
    case other
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
            return "Urina"
        case .stool:
            return "Fezes"
        case .task:
            return "Tarefa"
        case .symptom:
            return "Intercorrência"
        case .hydration:
            return "Hidratação"
        case .meal:
            return "Alimentação"
        }
    }
}
