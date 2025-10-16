//
//  StringExtensions.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 14/10/25.
//
import UIKit

extension String {
    func onlyDigits() -> String {
        filter(\.isNumber)
    }
    
    var lowerTrimmed: String { trimmingCharacters(in: .whitespacesAndNewlines).lowercased() }
}

public extension Double {
    var clean: String {
        let s = String(format: "%.2f", self)
        return s.replacingOccurrences(of: ".", with: ",")
    }
}
