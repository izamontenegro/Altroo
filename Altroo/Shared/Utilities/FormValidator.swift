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
}
