//
//  RoutineTask+Extensions.swift
//  Altroo
//
//  Created by Raissa Parente on 09/10/25.
//

import Foundation

//TODO: CHECK
extension RoutineTask {
    var weekdays: [Locale.Weekday] {
        get {
            guard let storedDays = daysOfTheWeek else { return [] }
            return storedDays.compactMap { Locale.Weekday(rawValue: $0) }
        }
        set {
            daysOfTheWeek = newValue.map { $0.rawValue }
        }
    }
}

extension TaskInstance {
    
    //TODO: TEST
    var isLatePeriod: Bool {
        guard !isDone else { return false }

        guard let dueDate = self.time else { return false }
        guard Calendar.current.isDateInToday(dueDate) else { return false }
        
        if self.period.orderIndex < PeriodEnum.current.orderIndex {
            return true
        }
        
        return false
    }
    
    
    var isLateDay: Bool {
        guard !isDone else { return false }
        
        guard let dueDate = self.time else { return false }
        guard !Calendar.current.isDateInToday(dueDate) else { return false }
        
        let today = Date()
        return dueDate < today
    }
    
    var period: PeriodEnum {
        PeriodEnum.period(for: time ?? .now) ?? .morning
    }
 
}
