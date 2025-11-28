//
//  DateFormarter.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 02/10/25.
//

import Foundation

final class DateFormatterHelper {
    private static let brLocale = Locale(identifier: "pt_BR")

    private static let longDayDF: DateFormatter = {
        let df = DateFormatter()
        df.locale = brLocale
        df.dateFormat = "d 'de' MMMM"
        return df
    }()
    
    private static let longDayYearDF: DateFormatter = {
        let df = DateFormatter()
        df.locale = brLocale
        df.dateFormat = "d 'de' MMMM 'de' YYYY"
        return df
    }()

    private static let timeHMDF: DateFormatter = {
        let df = DateFormatter()
        df.locale = brLocale
        df.dateFormat = "HH:mm"
        return df
    }()

    static func longDayString(from date: Date) -> String {
        longDayDF.string(from: date).capitalized
    }
    
    static func longDayYearString(from date: Date) -> String {
        longDayYearDF.string(from: date).capitalized
    }

    static func timeHMString(from date: Date) -> String {
        timeHMDF.string(from: date)
    }

    static func historyDateNumber(from date: Date) -> String {
        let df = DateFormatter()
        df.locale = brLocale
        df.setLocalizedDateFormatFromTemplate("dd/MM/yy")
        return df.string(from: date)
    }

    static func historyWeekdayShort(from date: Date) -> String {
        let df = DateFormatter()
        df.locale = brLocale
        df.setLocalizedDateFormatFromTemplate("EEEE")
        return df.string(from: date)
            .replacingOccurrences(of: "-feira", with: "")
            .capitalized
    }

    static func weekDayFormatter(date: Date) -> String {
        let df = DateFormatter()
        df.locale = brLocale
        df.dateFormat = "EEE"
        return df.string(from: date).uppercased()
    }

    static func dayFormatter(date: Date) -> String {
        let df = DateFormatter()
        df.locale = brLocale
        df.dateFormat = "d"
        return df.string(from: date).uppercased()
    }
    
    static func fullDayFormatter(date: Date) -> String {
        let df = DateFormatter()
        df.locale = brLocale
        df.dateFormat = "d/MM/YYYY"
        return df.string(from: date).uppercased()
    }

    static func hourFormatter(date: Date) -> String {
        timeHMString(from: date).uppercased()
    }
    
    static func birthDateFormatter(from date: Date?) -> String {
        guard let date else { return "Data não informada" }
        let df = DateFormatter()
        df.dateFormat = "dd/MM/yyyy"
        let dateString = df.string(from: date)
        let age = Calendar.current.dateComponents([.year], from: date, to: Date()).year ?? 0
        return "\(dateString) (\(age) anos)"
    }
    
    static func fullDateFormaterr(from date: Date?) -> String {
        guard let date else { return "Data não informada" }
        let df = DateFormatter()
        df.dateFormat = "dd/MM/yyyy"
        let dateString = df.string(from: date)
        return "\(dateString)"
    }
}
