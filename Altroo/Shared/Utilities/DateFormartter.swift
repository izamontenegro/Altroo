//
//  DateFormarter.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 02/10/25.
//

import Foundation

final class DateFormatterHelper {
    static func weekDayFormatter(date: Date) -> String {
        let weekdayFormatter = DateFormatter()
        weekdayFormatter.locale = Locale(identifier: "pt_BR")
        weekdayFormatter.dateFormat = "EEE"
        
        let formattedDate = weekdayFormatter.string(from: date).uppercased()
        return formattedDate
    }

    static func dayFormatter(date: Date) -> String {
        let dayFormatter = DateFormatter()
        dayFormatter.locale = Locale(identifier: "pt_BR")
        dayFormatter.dateFormat = "d"
        
        let formattedDate = dayFormatter.string(from: date).uppercased()
        return formattedDate
    }
    
    static func fullDayFormatter(date: Date) -> String {
        let dayFormatter = DateFormatter()
        dayFormatter.locale = Locale(identifier: "pt_BR")
        dayFormatter.dateFormat = "d/MM/YYYY"
        
        let formattedDate = dayFormatter.string(from: date).uppercased()
        return formattedDate
    }

    static func hourFormatter(date: Date) -> String {
        let hourFormatter = DateFormatter()
        hourFormatter.locale = Locale(identifier: "pt_BR")
        hourFormatter.dateFormat = "HH:mm"
        
        let formattedDate = hourFormatter.string(from: date).uppercased()
        return formattedDate
    }
    
    static func birthDateFormatter(from date: Date?) -> String {
        guard let date else { return "Data não informada" }
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let dateString = formatter.string(from: date)

        let age = Calendar.current.dateComponents([.year], from: date, to: Date()).year ?? 0
        return "\(dateString) (\(age) anos)"
    }
}
