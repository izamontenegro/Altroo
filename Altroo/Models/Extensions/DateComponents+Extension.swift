//
//  DateComponents+Extension.swift
//  Altroo
//
//  Created by Raissa Parente on 12/10/25.
//
import Foundation

extension DateComponents {
    func date(for day: Date) -> Date? {
        var calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day], from: day)
        components.hour = self.hour
        components.minute = self.minute
        return calendar.date(from: components)
    }
}
