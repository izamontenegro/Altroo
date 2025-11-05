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
            error = "Essa seção é obrigatória"
            return false
        } else {
            error = nil
            return true
        }
    }
    
    func invalidValue(value: Int, minValue: Int, maxValue: Int, error: inout String?) -> Bool {
        if value > maxValue || value < minValue {
            error = "Valor inválido."
            return false
        } else {
            error = nil
            return true
        }
    }
    
    //TODO
    func invalidPhoneFormat(value: Int, minValue: Int, maxValue: Int, error: inout String?) -> Bool {
        if value > maxValue || value < minValue {
            error = "Valor inválido"
            return false
        } else {
            error = nil
            return true
        }
    }
    
    func checkFutureDate(_ date: Date, error: inout String?) -> Bool {
        if Calendar.current.startOfDay(for: date) > .now {
            error = "A data não pode ser futura" //TODO: Redigir
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
            error = "Data final inválida" //TODO: Redigir
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
            error = "Assistido menor de 13 anos"
            return false
        } else {
            error = nil
            return true
        }
    }
}
