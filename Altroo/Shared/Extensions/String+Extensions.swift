//
//  String+Extensions.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 13/11/25.
//

import Foundation

// MARK: - FORMARTED NAME

extension String {
    var abbreviatedName: String {
        guard self.count > 16 else {
            return self
        }
        
        let parts = self.split(separator: " ")
        guard !parts.isEmpty else { return self }
        
        let firstName = String(parts.first!)
        let lastName = String(parts.last!)
        let combined = firstName + " " + lastName
        
        if combined.count < 16 {
            return combined
        }
        
        let lastInitial = lastName.first ?? " "
        return "\(firstName.capitalized) \(String(lastInitial).capitalized)."
    }
    
    func getInitials() -> String {
        let particles: Set<String> = ["de", "da", "das", "do", "dos"]
        
        let parts = self
            .lowercased()
            .components(separatedBy: .whitespacesAndNewlines)
            .filter { !$0.isEmpty && !particles.contains($0) }
        
        guard let first = parts.first, let last = parts.last else {
            return ""
        }
        
        let initials = "\(first.first!.uppercased())\(last.first!.uppercased())"
        return initials
    }
    
    var titleCasedName: String {
        let lowercaseExceptions = ["de", "da", "do", "dos", "das", "e"]
        
        return self
            .lowercased()
            .split(separator: " ")
            .enumerated()
            .map { index, word in
                if index != 0 && lowercaseExceptions.contains(word.lowercased()) {
                    return word.lowercased()
                }
                return word.prefix(1).uppercased() + word.dropFirst()
            }
            .joined(separator: " ")
    }
}
