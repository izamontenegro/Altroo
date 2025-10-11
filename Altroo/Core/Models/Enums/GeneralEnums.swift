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

enum PeriodEnum: String, CaseIterable {
    case morning
    case afternoon
    case evening
    case night
    
    var iconName: String {
        switch self {
        case .morning: "sun.min.fill"
        case .afternoon: "cloud.sun.fill"
        case .evening: "moon.stars.fill"
        case .night: "cloud.moon.fill"
        }
    }
    
    var name: String {
        switch self {
        case .morning: "Manhã"
        case .afternoon: "Tarde"
        case .evening: "Noite"
        case .night: "Madrugada"
        }
    }
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
