//
//  String+Extensions.swift
//  Altroo
//
//  Created by Raissa Parente on 11/11/25.
//
import Foundation

extension String {
    var abbreviatedName: String {
        guard self.count > 16 else { return self }
        
        let substrings = self.split(separator: " ")
        
        let firstName = "\(substrings.first ?? "")"
        let lastNameInitial = (substrings.last?.first) ?? " "
        
        guard firstName.count < 16 else { return firstName}
        
        let newName = "\(firstName.capitalized) \(String(lastNameInitial).capitalized)"
        
        return newName
    }
}
