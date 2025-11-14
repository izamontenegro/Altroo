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
    var isLateDay: Bool {
        guard !isDone else { return false }

        guard let dueDate = self.time else { return false }
        
        guard Calendar.current.isDateInToday(dueDate) else { return false }
        
        if self.period.orderIndex < PeriodEnum.current.orderIndex {
            return true
        }
        
        return false
    }
    
    
    var isLatePeriod: Bool {
        guard !isDone else { return false }
        
        guard let dueDate = self.time else { return false }
        guard !Calendar.current.isDateInToday(dueDate) else { return false }
        
        let today = Date()
        return dueDate > today
    }
    
    //TODO REFACTOR
    var period: PeriodEnum {
        let hour = Calendar.current.component(.hour, from: time!)
        
        switch hour {
        case 5..<12:
            return .morning
        case 12..<17:
            return .afternoon
        case 17..<21:
            return .night
        default:
            return .overnight
        }
    }
}
