//
//  Locale+Extensions.swift
//  Altroo
//
//  Created by Raissa Parente on 08/10/25.
//

import Foundation

extension Locale.Weekday:  @retroactive CaseIterable {
    
    public static var allCases: [Locale.Weekday] = [.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]
    
    static func from(calendarWeekday: Int) -> Locale.Weekday? {
            switch calendarWeekday {
            case 1: return .sunday
            case 2: return .monday
            case 3: return .tuesday
            case 4: return .wednesday
            case 5: return .thursday
            case 6: return .friday
            case 7: return .saturday
            default: return nil
            }
        }
}
