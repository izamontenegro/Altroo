//
//  PeriodEnum.swift
//  Altroo
//
//  Created by Raissa Parente on 14/11/25.
//
import Foundation

enum PeriodEnum: String, CaseIterable {
    case overnight
    case morning
    case afternoon
    case night
    
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
        case .overnight: return "overnight".localized
        case .morning:   return "morning".localized
        case .afternoon: return "afternoon".localized
        case .night:     return "night".localized
        }
    }
    
    var startTime: Int {
        switch self {
        case .morning: 6
        case .afternoon: 12
        case .night: 18
        case .overnight: 0
        }
    }

    var endTime: Int {
        switch self {
        case .morning: 12
        case .afternoon: 18
        case .night: 24
        case .overnight: 6
        }
    }
    
    var orderIndex: Int {
        switch self {
        case .morning: 0
        case .afternoon: 1
        case .night: 2
        case .overnight: 3
        }
    }
    
    static func shifts(for start: Date, end: Date) -> [PeriodEnum] {
        let calendar = Calendar.current
        let startHour = calendar.component(.hour, from: start)
        let endHour = calendar.component(.hour, from: end)
        var periods: [PeriodEnum] = []

        let ranges: [(PeriodEnum, Range<Int>)] = [
            (.morning, self.morning.startTime..<self.morning.endTime),
            (.afternoon, self.afternoon.startTime..<self.afternoon.endTime),
            (.night, self.night.startTime..<self.night.endTime),
            (.overnight, self.overnight.startTime..<self.overnight.endTime)
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
    
    static func period(for date: Date) -> PeriodEnum? {
        let hour = Calendar.current.component(.hour, from: date)

        let ranges: [(PeriodEnum, Range<Int>)] = [
            (.morning, self.morning.startTime..<self.morning.endTime),
            (.afternoon, self.afternoon.startTime..<self.afternoon.endTime),
            (.night, self.night.startTime..<self.night.endTime),
            (.overnight, self.overnight.startTime..<self.overnight.endTime)
        ]

        return ranges.first { (_, range) in
            range.contains(hour)
        }?.0
    }
    
    static var current: PeriodEnum {
        let hour = Calendar.current.component(.hour, from: Date())
        
        for period in PeriodEnum.allCases {
            let start = period.startTime
            let end = period.endTime
            
            if start < end {
                if (start..<end).contains(hour) {
                    return period
                }
            } else {
                if hour >= start || hour < end {
                    return period
                }
            }
        }
        
        return .night
    }

    var localizedCapitalized: String {
        return name.capitalized
    }
    
}
