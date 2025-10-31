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
    var userService: UserServiceProtocol
    
    @Published private(set) var sections: [MedicalRecordSectionVM] = []
    @Published private(set) var completionPercent: CGFloat = 0.0
    
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
        let surgeries = (healthProblems?.surgery as? [String])?.joined(separator: "\n") ?? "—"
        let allergies = (healthProblems?.allergies as? [String])?.joined(separator: ", ") ?? "—"
        let observation = healthProblems?.observation ?? "—"
        return """
        Doenças:
        \(diseasesList)

        Cirurgias
        \(surgeries)

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
        let equipments = MedicalRecordFormatter.bulletList(fromCSV: personalCare?.equipmentState)
        return """
        Banho: \(personalCare?.bathState ?? "—")
        Higiene: \(personalCare?.hygieneState ?? "—")
        Excreção: \(personalCare?.excretionState ?? "—")
        Alimentação: \(personalCare?.feedingState ?? "—")

        Equipamentos
        \(equipments.isEmpty ? "—" : equipments)
        """
    }
    
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
    
    private func rowsPersonalData(from careRecipient: CareRecipient) -> [InfoRow] {
        let personalData = careRecipient.personalData
        let name = personalData?.name ?? "—"
        let address = personalData?.address ?? "—"
        let dateOfBirth = DateFormatterHelper.birthDateFormatter(from: personalData?.dateOfBirth)
        let weight = MedicalRecordFormatter.formatKg(personalData?.weight)
        let height = MedicalRecordFormatter.formatMeters(personalData?.height)
        let contacts = MedicalRecordFormatter.contactsList(from: personalData?.contacts as? Set<Contact>)
        return [
            ("Nome", name),
            ("Data de Nascimento", dateOfBirth),
            ("Peso", weight),
            ("Altura", height),
            ("Endereço", address),
            ("Contatos", contacts)
        ]
    }
    
    private func rowsHealthProblems(from careRecipient: CareRecipient) -> [InfoRow] {
        let healthProblems = careRecipient.healthProblems
        let diseasesList = MedicalRecordFormatter.diseasesBulletList(from: healthProblems?.diseases as? Set<Disease>)
        let surgeries = (healthProblems?.surgery as? [String])?.joined(separator: "\n") ?? "—"
        let allergies = (healthProblems?.allergies as? [String])?.joined(separator: ", ") ?? "—"
        let observation = healthProblems?.observation ?? "—"
        return [
            ("Doenças", diseasesList),
            ("Cirurgias", surgeries),
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
        let equipments = MedicalRecordFormatter.bulletList(fromCSV: personalCare?.equipmentState)
        return [
            ("Banho", personalCare?.bathState ?? "—"),
            ("Higiene", personalCare?.hygieneState ?? "—"),
            ("Excreção", personalCare?.excretionState ?? "—"),
            ("Alimentação", personalCare?.feedingState ?? "—"),
            ("Equipamentos", equipments.isEmpty ? "—" : equipments)
        ]
    }
    
    private func calcCompletion(for careRecipient: CareRecipient) -> CGFloat {
        var total = 0, filled = 0
        func check(_ value: String?) { total += 1; if let x = value, !x.trimmingCharacters(in: .whitespaces).isEmpty { filled += 1 } }
        func checkDate(_ value: Date?) { total += 1; if value != nil { filled += 1 } }
        func checkDouble(_ value: Double?) { total += 1; if let x = value, !x.isNaN { filled += 1 } }
        func checkArray(_ value: Any?) { total += 1; if let a = value as? [Any], !a.isEmpty { filled += 1 } }
        
        let personalData = careRecipient.personalData
        check(personalData?.name)
        check(personalData?.address)
        check(personalData?.gender)
        checkDate(personalData?.dateOfBirth)
        checkDouble(personalData?.height)
        checkDouble(personalData?.weight)
        
        let healthProblems = careRecipient.healthProblems
        check(healthProblems?.observation)
        checkArray(healthProblems?.allergies)
        checkArray(healthProblems?.surgery)
        
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
