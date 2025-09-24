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

enum PeriodEnum: String {
    case morning
    case afternoon
    case evening
    case night
}

enum FrequencyEnum: String {
    case once
    case twice
    case threeTimes
    // ...
}

enum StatusEnum: String {
    case beforeLunch
    case afterLunch
    case other
}
