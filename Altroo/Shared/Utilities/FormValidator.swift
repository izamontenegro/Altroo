//
//  FormValidator.swift
//  Altroo
//
//  Created by Raissa Parente on 14/10/25.
//
import UIKit

class FormValidator {
    //FIXME: NOVO TEXTO
    func isEmpty(_ text: String, error: inout String?) -> Bool {
        if text.isEmpty {
            error = "required_section".localized
            return false
        } else {
            error = nil
            return true
        }
    }
    
    func invalidValue(value: Int, minValue: Int, maxValue: Int, error: inout String?) -> Bool {
        if value > maxValue || value < minValue {
            error = "invalid_value".localized
            return false
        } else {
            error = nil
            return true
        }
    }
    
    func invalidPhoneFormat(value: String, minValue: Int, maxValue: Int, error: inout String?) -> Bool {
        let trimmedValue = value.replacingOccurrences(of: " ", with: "")
        let isNumeric = !trimmedValue.isEmpty && trimmedValue.allSatisfy { $0.isNumber }

        guard isNumeric else {
            error = "invalid_value".localized
            return false
        }
        
        if trimmedValue.count < minValue || trimmedValue.count > maxValue {
            error = "invalid_value".localized
            return false
        }
        
        error = nil
        return true
    }
    
    func checkFutureDate(_ date: Date, error: inout String?) -> Bool {
        if Calendar.current.startOfDay(for: date) > .now {
            error = "invalid_future_date".localized //TODO: Redigir
            return false
        } else {
            error = nil
            return true
        }
    }
    
    
    func invalidDateRange(startDate: Date, endDate: Date, error: inout String?) -> Bool {
        let start = Calendar.current.startOfDay(for: startDate)
        let end = Calendar.current.startOfDay(for: endDate)

        if end < start {
            error = "invalid_end_date".localized //TODO: Redigir
            return false
        } else {
            error = nil
            return true
        }
    }
    
    func checkAge(_ age: Int, date: Date, error: inout String?) -> Bool {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let birthday = calendar.startOfDay(for: date)
        
        let difference = calendar.dateComponents([.year], from: birthday, to: today).year
        guard let difference else { return false }
        if  difference < 13 {
            error = "invalid_age".localized
            return false
        } else {
            error = nil
            return true
        }
    }
}
