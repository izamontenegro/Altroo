//
//  Locale+Extensions.swift
//  Altroo
//
//  Created by Raissa Parente on 08/10/25.
//

import Foundation

extension Locale.Weekday {
    public static var allWeekDays: [Locale.Weekday] = [
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday
        ]
    
    enum SymbolStyle {
        case veryShort   // "M", "T", "W"..
        case short       // "Mon", "Thu"..
        case full        // "Monday", etc.
    }
    
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
    
    func localizedSymbol(
        style: SymbolStyle = .veryShort,
        locale: Locale = .current
    ) -> String {
        var calendar = Calendar.current
        calendar.locale = locale
        
        let symbols: [String]
        
        switch style {
        case .veryShort:
            symbols = calendar.veryShortStandaloneWeekdaySymbols
        case .short:
            symbols = calendar.shortStandaloneWeekdaySymbols
        case .full:
            symbols = calendar.weekdaySymbols
        }
        
        let calendarIndex: Int
        
        switch self {
        case .sunday:    calendarIndex = 1
        case .monday:    calendarIndex = 2
        case .tuesday:   calendarIndex = 3
        case .wednesday: calendarIndex = 4
        case .thursday:  calendarIndex = 5
        case .friday:    calendarIndex = 6
        case .saturday:  calendarIndex = 7
        }
        
        return symbols[calendarIndex - 1]
    }
}
