//
//  TimeEnums.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 11/11/25.
//

import Foundation

enum PeriodEnum: String, CaseIterable {
    case morning
    case afternoon
    case night
    case overnight
    
    var iconName: String {
        switch self {
        case .morning: "sun.min.fill"
        case .afternoon: "cloud.sun.fill"
        case .night: "moon.stars.fill"
        case .overnight: "cloud.moon.fill"
        }
    }
    
    var name: String {
        switch self {
        case .morning: "morning".localized
        case .afternoon: "afternoon".localized
        case .night: "night".localized
        case .overnight: "overnight".localized
        }
    }
    
    static func shifts(for start: Date, end: Date) -> [PeriodEnum] {
        let calendar = Calendar.current
        let startHour = calendar.component(.hour, from: start)
        let endHour = calendar.component(.hour, from: end)
        var periods: [PeriodEnum] = []

        let ranges: [(PeriodEnum, Range<Int>)] = [
            (.morning, 5..<12),
            (.afternoon, 12..<17),
            (.night, 17..<21),
            (.overnight, 21..<24),
            (.overnight, 0..<5)
        ]

        for (period, range) in ranges {
            if range.overlaps(startHour..<endHour) {
                periods.append(period)
            }
        }

        if endHour < startHour {
            for (period, range) in ranges {
                if range.overlaps(startHour..<24) || range.overlaps(0..<endHour) {
                    periods.append(period)
                }
            }
        } else {
            for (period, range) in ranges {
                if range.overlaps(startHour..<endHour) {
                    periods.append(period)
                }
            }
        }

        let ordered: [PeriodEnum] = [.morning, .afternoon, .night, .overnight]
        return Array(Set(periods)).sorted { ordered.firstIndex(of: $0)! < ordered.firstIndex(of: $1)! }
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
