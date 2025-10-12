//
//  MedicalRecordSectionVM.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 12/10/25.
//
//
//
//// MedicalRecordViewModel.swift
//import UIKit
//import Combine
//
//public typealias InfoRow = (title: String, value: String)
//
//public struct MedicalRecordSectionVM {
//    public let title: String
//    public let iconSystemName: String
//    public let rows: [InfoRow]
//}
//
//final class MedicalRecordViewModel {
//    // Input
//    private(set) var person: CareRecipient
//
//    // Output
//    @Published private(set) var sections: [MedicalRecordSectionVM] = []
//    @Published private(set) var completionPercent: CGFloat = 0.0
//
//    init(person: CareRecipient) {
//        self.person = person
//        rebuildOutputs()
//    }
//
//    func update(person: CareRecipient) {
//        self.person = person
//        rebuildOutputs()
//    }
//
//    // MARK: - Public export texts
//    func personalDataText() -> String {
//        let r = person
//        let p = r.personalData
//        let name = p?.name ?? "—"
//        let address = p?.address ?? "—"
//        let dob = p?.dateOfBirth
//        let age = dob.map { " (\(Date().yearsSince($0)) anos)" } ?? ""
//        let dobStr = dob?.formattedBR() ?? "—"
//        let weight = r.personalData?.weight.map { "\($0.clean) Kg" } ?? "—"
//        let height = r.personalData?.height.map { "\($0.clean) m" } ?? "—"
//        let contacts: String = {
//            guard let set = r.personalData?.contacts as? Set<Contact>, !set.isEmpty else { return "—" }
//            return set.sorted { ($0.name ?? "") < ($1.name ?? "") }
//                     .map { "\($0.name ?? "Contato") \($0.description)" }
//                     .joined(separator: "\n")
//        }()
//        return """
//        Nome: \(name)
//        Data de Nascimento: \(dobStr)\(age)      Peso: \(weight)      Altura: \(height)
//        Endereço: \(address)
//        Contatos:
//        \(contacts)
//        """
//    }
//
//    func healthProblemsText() -> String {
//        let hp = person.healthProblems
//        let diseasesList: String = {
//            if let set = hp?.diseases as? Set<Disease>, !set.isEmpty {
//                return set.compactMap { $0.name }.sorted().map { "• \($0)" }.joined(separator: "\n")
//            }
//            return "—"
//        }()
//        let surgeries = (hp?.surgery as? [String])?.joined(separator: "\n") ?? "—"
//        let allergies = (hp?.allergies as? [String])?.joined(separator: ", ") ?? "—"
//        let obs = hp?.observation ?? "—"
//        return """
//        Doenças:
//        \(diseasesList)
//
//        Cirurgias
//        \(surgeries)
//
//        Alergias
//        \(allergies)
//
//        Observação
//        \(obs)
//        """
//    }
//
//    func physicalStateText() -> String {
//        let ph = person.physicalState
//        return """
//        Visão: \(ph?.visionState ?? "—")
//        Audição: \(ph?.hearingState ?? "—")
//        Locomoção: \(ph?.mobilityState ?? "—")
//        Saúde bucal: \(ph?.oralHealthState ?? "—")
//        """
//    }
//
//    func mentalStateText() -> String {
//        let m = person.mentalState
//        return """
//        Comportamento: \(m?.emotionalState ?? "—")
//        Orientação: \(m?.orientationState ?? "—")
//        Memória: \(m?.memoryState ?? "—")
//        Cognição: \(m?.cognitionState ?? "—")
//        """
//    }
//
//    func personalCareText() -> String {
//        let pc = person.personalCare
//        let equipments = (pc?.equipmentState ?? "")
//            .split(separator: ",")
//            .map { "• " + $0.trimmingCharacters(in: .whitespaces) }
//            .joined(separator: "\n")
//        return """
//        Banho: \(pc?.bathState ?? "—")
//        Higiene: \(pc?.hygieneState ?? "—")
//        Excreção: \(pc?.excretionState ?? "—")
//        Alimentação: \(pc?.feedingState ?? "—")
//
//        Equipamentos
//        \(equipments.isEmpty ? "—" : equipments)
//        """
//    }
//
//    // MARK: - Build outputs
//    private func rebuildOutputs() {
//        completionPercent = calcCompletion(for: person)
//        sections = [
//            .init(title: "Dados Pessoais", iconSystemName: "person.fill", rows: rowsPersonalData(from: person)),
//            .init(title: "Problemas de Saúde", iconSystemName: "heart.fill", rows: rowsHealthProblems(from: person)),
//            .init(title: "Estado físico", iconSystemName: "figure", rows: rowsPhysical(from: person)),
//            .init(title: "Estado Mental", iconSystemName: "brain.head.profile.fill", rows: rowsMental(from: person)),
//            .init(title: "Cuidados Pessoais", iconSystemName: "hand.raised.fill", rows: rowsPersonalCare(from: person))
//        ]
//    }
//
//    // MARK: - Rows
//    private func rowsPersonalData(from r: CareRecipient) -> [InfoRow] {
//        let p = r.personalData
//        let name = p?.name ?? "—"
//        let address = p?.address ?? "—"
//        let dob = p?.dateOfBirth
//        let age = dob.map { " (\(Date().yearsSince($0)) anos)" } ?? ""
//        let dobStr = dob?.formattedBR() ?? "—"
//        let weight = r.personalData?.weight.map { "\($0.clean) Kg" } ?? "—"
//        let height = r.personalData?.height.map { "\($0.clean) m" } ?? "—"
//        let contacts: String = {
//            guard let set = r.personalData?.contacts as? Set<Contact>, !set.isEmpty else { return "—" }
//            return set.sorted { ($0.name ?? "") < ($1.name ?? "") }
//                     .map { "\($0.name ?? "Contato") \($0.description)" }
//                     .joined(separator: "\n")
//        }()
//        return [
//            ("Nome", name),
//            ("Data de Nascimento", "\(dobStr)\(age)"),
//            ("Peso", weight),
//            ("Altura", height),
//            ("Endereço", address),
//            ("Contatos", contacts)
//        ]
//    }
//
//    private func rowsHealthProblems(from r: CareRecipient) -> [InfoRow] {
//        let hp = r.healthProblems
//        let diseasesList: String = {
//            if let set = hp?.diseases as? Set<Disease>, !set.isEmpty {
//                return set.compactMap { $0.name }.sorted().map { "• \($0)" }.joined(separator: "\n")
//            }
//            return "—"
//        }()
//        let surgeries = (hp?.surgery as? [String])?.joined(separator: "\n") ?? "—"
//        let allergies = (hp?.allergies as? [String])?.joined(separator: ", ") ?? "—"
//        let obs = hp?.observation ?? "—"
//        return [
//            ("Doenças", diseasesList),
//            ("Cirurgias", surgeries),
//            ("Alergias", allergies),
//            ("Observação", obs)
//        ]
//    }
//
//    private func rowsPhysical(from r: CareRecipient) -> [InfoRow] {
//        let ph = r.physicalState
//        return [
//            ("Visão", ph?.visionState ?? "—"),
//            ("Audição", ph?.hearingState ?? "—"),
//            ("Locomoção", ph?.mobilityState ?? "—"),
//            ("Saúde bucal", ph?.oralHealthState ?? "—")
//        ]
//    }
//
//    private func rowsMental(from r: CareRecipient) -> [InfoRow] {
//        let m = r.mentalState
//        return [
//            ("Comportamento", m?.emotionalState ?? "—"),
//            ("Orientação", m?.orientationState ?? "—"),
//            ("Memória", m?.memoryState ?? "—"),
//            ("Cognição", m?.cognitionState ?? "—")
//        ]
//    }
//
//    private func rowsPersonalCare(from r: CareRecipient) -> [InfoRow] {
//        let pc = r.personalCare
//        let equipments = (pc?.equipmentState ?? "")
//            .split(separator: ",")
//            .map { "• " + $0.trimmingCharacters(in: .whitespaces) }
//            .joined(separator: "\n")
//        return [
//            ("Banho", pc?.bathState ?? "—"),
//            ("Higiene", pc?.hygieneState ?? "—"),
//            ("Excreção", pc?.excretionState ?? "—"),
//            ("Alimentação", pc?.feedingState ?? "—"),
//            ("Equipamentos", equipments.isEmpty ? "—" : equipments)
//        ]
//    }
//
//    // MARK: - Completion
//    private func calcCompletion(for r: CareRecipient) -> CGFloat {
//        var total = 0, filled = 0
//        func check(_ v: String?) { total += 1; if let x = v, !x.trimmingCharacters(in: .whitespaces).isEmpty { filled += 1 } }
//        func checkD(_ v: Date?) { total += 1; if v != nil { filled += 1 } }
//        func checkDbl(_ v: Double?) { total += 1; if let x = v, !x.isNaN { filled += 1 } }
//        func checkArr(_ v: Any?) { total += 1; if let a = v as? [Any], !a.isEmpty { filled += 1 } }
//
//        let pd = r.personalData
//        check(pd?.name); check(pd?.address); check(pd?.gender)
//        checkD(pd?.dateOfBirth); checkDbl(pd?.height); checkDbl(pd?.weight)
//
//        let hp = r.healthProblems
//        check(hp?.observation); checkArr(hp?.allergies); checkArr(hp?.surgery)
//
//        let m = r.mentalState
//        check(m?.cognitionState); check(m?.emotionalState); check(m?.memoryState); check(m?.orientationState)
//
//        let ph = r.physicalState
//        check(ph?.mobilityState); check(ph?.hearingState); check(ph?.visionState); check(ph?.oralHealthState)
//
//        let pc = r.personalCare
//        check(pc?.bathState); check(pc?.hygieneState); check(pc?.excretionState); check(pc?.feedingState); check(pc?.equipmentState)
//
//        guard total > 0 else { return 0.0 }
//        return CGFloat(Double(filled) / Double(total))
//    }
//}
