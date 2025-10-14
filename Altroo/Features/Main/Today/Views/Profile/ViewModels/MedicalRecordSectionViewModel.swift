//
//  MedicalRecordSectionVM.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 12/10/25.
//

import UIKit
import Combine

public typealias InfoRow = (title: String, value: String)

public struct MedicalRecordSectionVM {
    public let title: String
    public let iconSystemName: String
    public let rows: [InfoRow]
}

final class MedicalRecordViewModel {
    // MARK: - Dependencies
    var userService: UserServiceProtocol
    
    // MARK: - Input

    // MARK: - Output
    @Published private(set) var sections: [MedicalRecordSectionVM] = []
    @Published private(set) var completionPercent: CGFloat = 0.0

    // MARK: - Init
        init(userService: UserServiceProtocol) {
            self.userService = userService
            rebuildOutputs()
        }

        func reload() {
            rebuildOutputs()
        }
    // MARK: - Public export texts (usados para PDF/compartilhamento)
//    func personalDataText() -> String {
//        guard let person = currentPatient() else { return "Sem paciente selecionado." }
////        rebuildOutputs()
//        return "oi"
//    }

//    func update(person: CareRecipient) {
//        self.person = person
//        rebuildOutputs()
//    }

    // MARK: - Public export texts (usados para PDF/compartilhamento)
    func personalDataText(person: CareRecipient) -> String {
        let p = person.personalData
        let name = p?.name ?? "—"
        let address = p?.address ?? "—"
        let dob = dobWithAge(p?.dateOfBirth)
        let weight = kg(p?.weight)
        let height = meters(p?.height)
        let contacts: String = contactsList(from: p?.contacts as? Set<Contact>)
        return """
        Nome: \(name)
        Data de Nascimento: \(dob)      Peso: \(weight)      Altura: \(height)
        Endereço: \(address)
        Contatos:
        \(contacts)
        """
    }
    
    func healthProblemsText(person: CareRecipient) -> String {
        guard let person = currentPatient() else { return "Sem paciente selecionado." }
        let hp = person.healthProblems
        let diseasesList = diseasesBulletList(from: hp?.diseases as? Set<Disease>)
        let surgeries = (hp?.surgery as? [String])?.joined(separator: "\n") ?? "—"
        let allergies = (hp?.allergies as? [String])?.joined(separator: ", ") ?? "—"
        let obs = hp?.observation ?? "—"
        return """
        Doenças:
        \(diseasesList)

        Cirurgias
        \(surgeries)

        Alergias
        \(allergies)

        Observação
        \(obs)
        """
    }
       
    func physicalStateText(person: CareRecipient) -> String {
        guard let person = currentPatient() else { return "Sem paciente selecionado." }
        let ph = person.physicalState
        return """
        Visão: \(ph?.visionState ?? "—")
        Audição: \(ph?.hearingState ?? "—")
        Locomoção: \(ph?.mobilityState ?? "—")
        Saúde bucal: \(ph?.oralHealthState ?? "—")
        """
    }

    func mentalStateText(person: CareRecipient) -> String {
        guard let person = currentPatient() else { return "Sem paciente selecionado." }
        let m = person.mentalState
        return """
        Comportamento: \(m?.emotionalState ?? "—")
        Orientação: \(m?.orientationState ?? "—")
        Memória: \(m?.memoryState ?? "—")
        Cognição: \(m?.cognitionState ?? "—")
        """
    }

    func personalCareText(person: CareRecipient) -> String {
        guard let person = currentPatient() else { return "Sem paciente selecionado." }
        let pc = person.personalCare
        let equipments = bulletList(fromCSV: pc?.equipmentState)
        return """
        Banho: \(pc?.bathState ?? "—")
        Higiene: \(pc?.hygieneState ?? "—")
        Excreção: \(pc?.excretionState ?? "—")
        Alimentação: \(pc?.feedingState ?? "—")

        Equipamentos
        \(equipments.isEmpty ? "—" : equipments)
        """
    }

    // MARK: - Build outputs

    private func rebuildOutputs() {
        guard let person = currentPatient() else {
            completionPercent = 0
            sections = []
            return
        }
        completionPercent = calcCompletion(for: person)
        sections = [
            .init(title: "Dados Pessoais", iconSystemName: "person.fill", rows: rowsPersonalData(from: person)),
            .init(title: "Problemas de Saúde", iconSystemName: "heart.fill", rows: rowsHealthProblems(from: person)),
            .init(title: "Estado físico", iconSystemName: "figure", rows: rowsPhysical(from: person)),
            .init(title: "Estado Mental", iconSystemName: "brain.head.profile.fill", rows: rowsMental(from: person)),
            .init(title: "Cuidados Pessoais", iconSystemName: "hand.raised.fill", rows: rowsPersonalCare(from: person))
        ]
    }

    // MARK: - Accessor centralizado
    private func currentPatient() -> CareRecipient? {
        userService.fetchCurrentPatient()
    }

    // MARK: - Rows
    private func rowsPersonalData(from r: CareRecipient) -> [InfoRow] {
        let p = r.personalData
        let name = p?.name ?? "—"
        let address = p?.address ?? "—"
        let dob = dobWithAge(p?.dateOfBirth)
        let weight = kg(p?.weight)
        let height = meters(p?.height)
        let contacts = contactsList(from: p?.contacts as? Set<Contact>)
        return [
            ("Nome", name),
            ("Data de Nascimento", dob),
            ("Peso", weight),
            ("Altura", height),
            ("Endereço", address),
            ("Contatos", contacts)
        ]
    }

    private func rowsHealthProblems(from r: CareRecipient) -> [InfoRow] {
        let hp = r.healthProblems
        let diseasesList = diseasesBulletList(from: hp?.diseases as? Set<Disease>)
        let surgeries = (hp?.surgery as? [String])?.joined(separator: "\n") ?? "—"
        let allergies = (hp?.allergies as? [String])?.joined(separator: ", ") ?? "—"
        let obs = hp?.observation ?? "—"
        return [
            ("Doenças", diseasesList),
            ("Cirurgias", surgeries),
            ("Alergias", allergies),
            ("Observação", obs)
        ]
    }

    private func rowsPhysical(from r: CareRecipient) -> [InfoRow] {
        let ph = r.physicalState
        return [
            ("Visão", ph?.visionState ?? "—"),
            ("Audição", ph?.hearingState ?? "—"),
            ("Locomoção", ph?.mobilityState ?? "—"),
            ("Saúde bucal", ph?.oralHealthState ?? "—")
        ]
    }

    private func rowsMental(from r: CareRecipient) -> [InfoRow] {
        let m = r.mentalState
        return [
            ("Comportamento", m?.emotionalState ?? "—"),
            ("Orientação", m?.orientationState ?? "—"),
            ("Memória", m?.memoryState ?? "—"),
            ("Cognição", m?.cognitionState ?? "—")
        ]
    }

    private func rowsPersonalCare(from r: CareRecipient) -> [InfoRow] {
        let pc = r.personalCare
        let equipments = bulletList(fromCSV: pc?.equipmentState)
        return [
            ("Banho", pc?.bathState ?? "—"),
            ("Higiene", pc?.hygieneState ?? "—"),
            ("Excreção", pc?.excretionState ?? "—"),
            ("Alimentação", pc?.feedingState ?? "—"),
            ("Equipamentos", equipments.isEmpty ? "—" : equipments)
        ]
    }

    // MARK: - Completion
    private func calcCompletion(for r: CareRecipient) -> CGFloat {
        var total = 0, filled = 0
        func check(_ v: String?) { total += 1; if let x = v, !x.trimmingCharacters(in: .whitespaces).isEmpty { filled += 1 } }
        func checkD(_ v: Date?) { total += 1; if v != nil { filled += 1 } }
        func checkDbl(_ v: Double?) { total += 1; if let x = v, !x.isNaN { filled += 1 } }
        func checkArr(_ v: Any?) { total += 1; if let a = v as? [Any], !a.isEmpty { filled += 1 } }

        let pd = r.personalData
        check(pd?.name); check(pd?.address); check(pd?.gender)
        checkD(pd?.dateOfBirth); checkDbl(pd?.height); checkDbl(pd?.weight)

        let hp = r.healthProblems
        check(hp?.observation); checkArr(hp?.allergies); checkArr(hp?.surgery)

        let m = r.mentalState
        check(m?.cognitionState); check(m?.emotionalState); check(m?.memoryState); check(m?.orientationState)

        let ph = r.physicalState
        check(ph?.mobilityState); check(ph?.hearingState); check(ph?.visionState); check(ph?.oralHealthState)

        let pc = r.personalCare
        check(pc?.bathState); check(pc?.hygieneState); check(pc?.excretionState); check(pc?.feedingState); check(pc?.equipmentState)

        guard total > 0 else { return 0.0 }
        return CGFloat(Double(filled) / Double(total))
    }

    // MARK: - Local helpers
    private func kg(_ v: Double?) -> String {
        guard let v else { return "—" }
        return "\(v.clean) Kg"
    }

    private func meters(_ v: Double?) -> String {
        guard let v else { return "—" }
        return "\(v.clean) m"
    }

    private func dobWithAge(_ dob: Date?) -> String {
        guard let d = dob else { return "—" }
        let age = Date().yearsSince(d)
        return "\(d.formattedBR()) (\(age) anos)"
    }

    private func contactsList(from set: Set<Contact>?) -> String {
        guard let set, !set.isEmpty else { return "—" }
        return set
            .sorted { ($0.name ?? "") < ($1.name ?? "") }
            .map { "\($0.name ?? "Contato") \($0.description)" }
            .joined(separator: "\n")
    }

    private func diseasesBulletList(from set: Set<Disease>?) -> String {
        guard let set, !set.isEmpty else { return "—" }
        return set.compactMap { $0.name }.sorted().map { "• \($0)" }.joined(separator: "\n")
    }

    private func bulletList(fromCSV csv: String?) -> String {
        let raw = (csv ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        guard !raw.isEmpty else { return "" }
        return raw
            .split(separator: ",")
            .map { "• " + $0.trimmingCharacters(in: .whitespaces) }
            .joined(separator: "\n")
    }
}

// MARK: - Utils
public extension Date {
    func yearsSince(_ other: Date) -> Int {
        Calendar.current.dateComponents([.year], from: other, to: self).year ?? 0
    }
    func formattedBR() -> String {
        let f = DateFormatter()
        f.locale = Locale(identifier: "pt_BR")
        f.dateFormat = "dd/MM/yyyy"
        return f.string(from: self)
    }
}

public extension Double {
    var clean: String {
        let s = String(format: "%.2f", self)
        return s.replacingOccurrences(of: ".", with: ",")
    }
}
