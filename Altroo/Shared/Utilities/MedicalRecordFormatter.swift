//
//  MedicalRecordFormatter.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 16/10/25.
//


import Foundation

enum MedicalRecordFormatter {

    static func formatKg(_ v: Double?) -> String {
        guard let v else { return "—" }
        return "\(v.clean) Kg"
    }

    static func formatMeters(_ v: Double?) -> String {
        guard let v else { return "—" }
        return "\(v.clean) m"
    }

    static func contactsList(from set: Set<Contact>?) -> String {
        guard let set, !set.isEmpty else { return "—" }
        return set
            .sorted { ($0.name ?? "") < ($1.name ?? "") }
            .map { "\($0.name ?? "Contato") \(String(describing: $0.contactDescription))" }
            .joined(separator: "\n")
    }

    static func diseasesBulletList(from set: Set<Disease>?) -> String {
        guard let set, !set.isEmpty else { return "—" }
        return set
            .compactMap { $0.name }
            .sorted()
            .map { "• \($0)" }
            .joined(separator: "\n")
    }

    static func bulletList(fromCSV csv: String?) -> String {
        let raw = (csv ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        guard !raw.isEmpty else { return "" }
        return raw
            .split(separator: ",")
            .map { "• " + $0.trimmingCharacters(in: .whitespaces) }
            .joined(separator: "\n")
    }
}
