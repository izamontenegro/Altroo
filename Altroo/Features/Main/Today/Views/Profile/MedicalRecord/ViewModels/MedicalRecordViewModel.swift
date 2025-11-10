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

public struct ContactDisplayItem {
    public let name: String
    public let relation: String?
    public let phone: String
}

final class MedicalRecordViewModel {
    var userService: UserServiceProtocol
    
    @Published private(set) var sections: [MedicalRecordSectionVM] = []
    @Published private(set) var completionPercent: CGFloat = 0.0

    var surgeryDisplayItems: [(title: String, primary: String, secondary: String)] = []
    var contactDisplayItems: [ContactDisplayItem] = []
    
    private let surgeryDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter
    }()
    
    init(userService: UserServiceProtocol) {
        self.userService = userService
        rebuildOutputs()
    }
    
    func reload() {
        rebuildOutputs()
    }
    
    private func currentPatient() -> CareRecipient? {
        userService.fetchCurrentPatient()
    }

    func personalDataText(person: CareRecipient) -> String {
        let personalData = person.personalData
        let name = personalData?.name ?? "—"
        let address = personalData?.address ?? "—"
        let dateOfBirth = DateFormatterHelper.birthDateFormatter(from: personalData?.dateOfBirth)
        let weight = MedicalRecordFormatter.formatKg(personalData?.weight)
        let height = MedicalRecordFormatter.formatMeters(personalData?.height)
        let contacts = MedicalRecordFormatter.contactsList(from: personalData?.contacts as? Set<Contact>)
        return """
        Nome: \(name)
        Data de Nascimento: \(dateOfBirth)      Peso: \(weight)      Altura: \(height)
        Endereço: \(address)
        Contatos:
        \(contacts)
        """
    }

    func healthProblemsText(person: CareRecipient) -> String {
        let healthProblems = person.healthProblems
        let diseasesList = MedicalRecordFormatter.diseasesBulletList(from: healthProblems?.diseases as? Set<Disease>)
        
        let surgeriesSet = healthProblems?.surgeries as? Set<Surgery> ?? []
        let surgeriesBlocks = surgeriesSet
            .sorted { ($0.date ?? .distantPast) < ($1.date ?? .distantPast) }
            .map { surgery -> String in
                let name = surgery.name ?? "—"
                let dateString = surgery.date.map { surgeryDateFormatter.string(from: $0) } ?? "—"
                return "\(name)\n\(dateString)"
            }
            .joined(separator: "\n\n")
        let surgeriesText = surgeriesBlocks.isEmpty ? "—" : surgeriesBlocks
        
        let allergies = healthProblems?.allergies ?? "—"
        let observation = healthProblems?.observation ?? "—"
        return """
        Doenças:
        \(diseasesList)

        Cirurgias
        \(surgeriesText)

        Alergias
        \(allergies)

        Observação
        \(observation)
        """
    }

    func physicalStateText(person: CareRecipient) -> String {
        let physicalState = person.physicalState
        let vision = physicalState?.visionState.flatMap { VisionEnum(rawValue: $0)?.displayText } ?? "—"
        let hearing = physicalState?.hearingState.flatMap { HearingEnum(rawValue: $0)?.displayText } ?? "—"
        let mobility = physicalState?.mobilityState.flatMap { MobilityEnum(rawValue: $0)?.displayText } ?? "—"
        let oral = physicalState?.oralHealthState.flatMap { OralHealthEnum(rawValue: $0)?.displayText } ?? "—"
        return """
        Visão: \(vision)
        Audição: \(hearing)
        Locomoção: \(mobility)
        Saúde bucal: \(oral)
        """
    }

    func mentalStateText(person: CareRecipient) -> String {
        let mentalState = person.mentalState
        let emotional = mentalState?.emotionalState.flatMap { EmotionalStateEnum(rawValue: $0)?.displayText } ?? "—"
        let orientation = mentalState?.orientationState.flatMap { OrientationEnum(rawValue: $0)?.displayText } ?? "—"
        let memory = mentalState?.memoryState.flatMap { MemoryEnum(rawValue: $0)?.displayText } ?? "—"
        return """
        Comportamento: \(emotional)
        Orientação: \(orientation)
        Memória: \(memory)
        """
    }

    func personalCareText(person: CareRecipient) -> String {
        let personalCare = person.personalCare

        let bath = personalCare?.bathState.flatMap { BathEnum(rawValue: $0)?.displayText } ?? "—"
        let hygiene = personalCare?.hygieneState.flatMap { HygieneEnum(rawValue: $0)?.displayText } ?? "—"
        let excretion = personalCare?.excretionState.flatMap { ExcretionEnum(rawValue: $0)?.displayText } ?? "—"
        let feeding = personalCare?.feedingState.flatMap { FeedingEnum(rawValue: $0)?.displayText } ?? "—"
        let equipments = personalCare?.equipmentState ?? "—"

        return """
        Banho: \(bath)
        Higiene: \(hygiene)
        Excreção: \(excretion)
        Alimentação: \(feeding)

        Equipamentos
        \(equipments)
        """
    }
    
    private func rebuildOutputs() {
        guard let person = currentPatient() else {
            completionPercent = 0
            sections = []
            surgeryDisplayItems = []
            contactDisplayItems = []
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
    
    private func rowsPersonalData(from careRecipient: CareRecipient) -> [InfoRow] {
        let personalData = careRecipient.personalData
        let name = personalData?.name ?? "—"
        let address = personalData?.address ?? "—"
        let dateOfBirth = DateFormatterHelper.birthDateFormatter(from: personalData?.dateOfBirth)
        let weight = MedicalRecordFormatter.formatKg(personalData?.weight)
        let height = MedicalRecordFormatter.formatMeters(personalData?.height)

        contactDisplayItems = []
        if let contactsSet = personalData?.contacts as? Set<Contact>, !contactsSet.isEmpty {
            let ordered = contactsSet.sorted { (l, r) in
                let ln = l.name ?? ""
                let rn = r.name ?? ""
                return ln.localizedCaseInsensitiveCompare(rn) == .orderedAscending
            }

            for (index, c) in ordered.enumerated() {
                let displayName = c.name ?? "—"
                let relationText = c.relationship
                let phoneText = c.phone ?? "—"

                contactDisplayItems.append(
                    .init(name: displayName, relation: relationText, phone: phoneText)
                )
            }
        }

        let contactsText: String = contactDisplayItems.isEmpty ? "—" : ""

        return [
            ("Nome", name),
            ("Data de Nascimento", dateOfBirth),
            ("Peso", weight),
            ("Altura", height),
            ("Endereço", address),
            ("Contatos", contactsText)
        ]
    }
    
    private func rowsHealthProblems(from careRecipient: CareRecipient) -> [InfoRow] {
        let healthProblems = careRecipient.healthProblems
        let diseasesList = MedicalRecordFormatter.diseasesBulletList(from: healthProblems?.diseases as? Set<Disease>)
        
        surgeryDisplayItems = []
        let surgeriesSet = healthProblems?.surgeries as? Set<Surgery> ?? []
        let sortedSurgeries = surgeriesSet
            .sorted { ($0.date ?? .distantPast) < ($1.date ?? .distantPast) }
        
        for surgery in sortedSurgeries {
            let name = surgery.name ?? "—"
            let dateString = surgery.date.map { surgeryDateFormatter.string(from: $0) } ?? "—"
            surgeryDisplayItems.append((title: "Cirurgias", primary: name, secondary: dateString))
        }
        
        let surgeriesRow: InfoRow = surgeryDisplayItems.isEmpty ? ("Cirurgias", "—") : ("Cirurgias", "")
        
        let allergies = healthProblems?.allergies ?? "—"
        let observation = healthProblems?.observation ?? "—"
        return [
            ("Doenças", diseasesList),
            surgeriesRow,
            ("Alergias", allergies),
            ("Observação", observation)
        ]
    }
    
    private func rowsPhysical(from careRecipient: CareRecipient) -> [InfoRow] {
        let physicalState = careRecipient.physicalState
        let vision = physicalState?.visionState.flatMap { VisionEnum(rawValue: $0)?.displayText } ?? "—"
        let hearing = physicalState?.hearingState.flatMap { HearingEnum(rawValue: $0)?.displayText } ?? "—"
        let mobility = physicalState?.mobilityState.flatMap { MobilityEnum(rawValue: $0)?.displayText } ?? "—"
        let oral = physicalState?.oralHealthState.flatMap { OralHealthEnum(rawValue: $0)?.displayText } ?? "—"
        return [
            ("Visão", vision),
            ("Audição", hearing),
            ("Locomoção", mobility),
            ("Saúde bucal", oral)
        ]
    }
    
    private func rowsMental(from careRecipient: CareRecipient) -> [InfoRow] {
        let mentalState = careRecipient.mentalState
        let emotional = mentalState?.emotionalState.flatMap { EmotionalStateEnum(rawValue: $0)?.displayText } ?? "—"
        let orientation = mentalState?.orientationState.flatMap { OrientationEnum(rawValue: $0)?.displayText } ?? "—"
        let memory = mentalState?.memoryState.flatMap { MemoryEnum(rawValue: $0)?.displayText } ?? "—"
        return [
            ("Comportamento", emotional),
            ("Orientação", orientation),
            ("Memória", memory),
        ]
    }
    
    private func rowsPersonalCare(from careRecipient: CareRecipient) -> [InfoRow] {
        let personalCare = careRecipient.personalCare

        let bath = personalCare?.bathState.flatMap { BathEnum(rawValue: $0)?.displayText } ?? "—"
        let hygiene = personalCare?.hygieneState.flatMap { HygieneEnum(rawValue: $0)?.displayText } ?? "—"
        let excretion = personalCare?.excretionState.flatMap { ExcretionEnum(rawValue: $0)?.displayText } ?? "—"
        let feeding = personalCare?.feedingState.flatMap { FeedingEnum(rawValue: $0)?.displayText } ?? "—"
        let equipments = personalCare?.equipmentState ?? "—"

        return [
            ("Banho", bath),
            ("Higiene", hygiene),
            ("Excreção", excretion),
            ("Alimentação", feeding),
            ("Equipamentos", equipments)
        ]
    }
    
    private func calcCompletion(for careRecipient: CareRecipient) -> CGFloat {
        var total = 0, filled = 0
        func check(_ value: String?) { total += 1; if let x = value, !x.trimmingCharacters(in: .whitespaces).isEmpty { filled += 1 } }
        func checkDate(_ value: Date?) { total += 1; if value != nil { filled += 1 } }
        func checkDouble(_ value: Double?) { total += 1; if let x = value, !x.isNaN { filled += 1 } }
        func checkArray(_ value: Any?) { total += 1; if let a = value as? [Any], !a.isEmpty { filled += 1 } }
        func checkToManySet<T>(_ value: Set<T>?) { total += 1; if let set = value, !set.isEmpty { filled += 1 } }
        
        let personalData = careRecipient.personalData
        check(personalData?.name)
        check(personalData?.address)
        check(personalData?.gender)
        checkDate(personalData?.dateOfBirth)
        checkDouble(personalData?.height)
        checkDouble(personalData?.weight)
        
        let healthProblems = careRecipient.healthProblems
        check(healthProblems?.observation)
        check(healthProblems?.allergies)
        
        let mentalState = careRecipient.mentalState
        check(mentalState?.cognitionState)
        check(mentalState?.emotionalState)
        check(mentalState?.memoryState)
        check(mentalState?.orientationState)
        
        let physicalState = careRecipient.physicalState
        check(physicalState?.mobilityState)
        check(physicalState?.hearingState)
        check(physicalState?.visionState)
        check(physicalState?.oralHealthState)
        
        let personalCare = careRecipient.personalCare
        check(personalCare?.bathState)
        check(personalCare?.hygieneState)
        check(personalCare?.excretionState)
        check(personalCare?.feedingState)
        check(personalCare?.equipmentState)
        
        guard total > 0 else { return 0.0 }
        return CGFloat(Double(filled) / Double(total))
    }
}
