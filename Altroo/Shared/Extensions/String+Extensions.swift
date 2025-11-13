//
//  String+Extensions.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 13/11/25.
//

import Foundation

// MARK: - FORMARTED NAME

extension String {
    
    func shortenedName(maxLength: Int = 16) -> String {
        let trimmed = self.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty { return self }
        
        let parts = trimmed
            .components(separatedBy: .whitespacesAndNewlines)
            .filter { !$0.isEmpty }
            .map { $0.toTitleCase() }
        
        if parts.count == 1 {
            return parts[0]
        }
        
        func tryBuild(_ builder: () -> String) -> String? {
            let name = builder()
            return name.count <= maxLength ? name : nil
        }
        
        let first = parts[0]
        let surnames = Array(parts.dropFirst())
        
        if let result = tryBuild({ ([first] + surnames).joined(separator: " ") }) {
            return result
        }
        
        if surnames.count > 1 {
            if let result = tryBuild({
                let lastSurname = surnames.last!
                let middle = surnames.dropLast().map { $0.toInitialWithDot() }
                return ([first] + middle + [lastSurname]).joined(separator: " ")
            }) {
                return result
            }
        }
        
        if let result = tryBuild({
            let allAbbrev = surnames.map { $0.toInitialWithDot() }
            return ([first] + allAbbrev).joined(separator: " ")
        }) {
            return result
        }
        
        if let result = tryBuild({
            let firstAbbrev = first.toInitialWithDot()
            let allAbbrev = surnames.map { $0.toInitialWithDot() }
            return ([firstAbbrev] + allAbbrev).joined(separator: " ")
        }) {
            return result
        }
        
        let fallback = ([first] + surnames).joined(separator: " ")
        return String(fallback.prefix(maxLength))
    }
}

private extension String {
    func toTitleCase() -> String {
        guard let first = self.unicodeScalars.first else { return self }
        let firstChar = String(first).uppercased()
        let rest = String(self.unicodeScalars.dropFirst()).lowercased()
        return firstChar + rest
    }
    
    func toInitialWithDot() -> String {
        guard let first = self.unicodeScalars.first else { return self }
        return String(first).uppercased() + "."
    }
}

// MARK: - GET INITIALS
extension String {
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
}
