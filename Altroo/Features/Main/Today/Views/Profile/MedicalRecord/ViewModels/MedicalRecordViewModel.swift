//
//  MedicalRecordSectionVM.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 12/10/25.
//
import UIKit
import Combine

public typealias InformationRow = (title: String, value: String)

public struct MedicalRecordSectionViewModel {
    public let title: String
    public let iconSystemName: String
    public let rows: [InformationRow]
}

public struct ContactDisplayItem {
    public let name: String
    public let relationship: String?
    public let phone: String
}

public struct SurgeryDisplayItem {
    public let title: String
    public let primary: String
    public let secondary: String
}

final class MedicalRecordViewModel {
    var userService: UserServiceProtocol
    
    @Published private(set) var sections: [MedicalRecordSectionViewModel] = []
    @Published private(set) var completionPercentage: CGFloat = 0.0

    var surgeryDisplayItems: [SurgeryDisplayItem] = []
    var contactDisplayItems: [ContactDisplayItem] = []
    
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
    
    func getUpdatedAt() -> String {
        guard let person = currentPatient() else { return "" }
        
        return DateFormatterHelper.birthDateFormatter(from: person.recordUpdatedAt)
    }
    
    // MARK: - PERSONAL DATA
    
    func getName() -> String {
        let personalData = currentPatient()?.personalData
        let name = personalData?.name ?? "Sem registro"
        
        return name
    }
    
    func getAddress() -> String {
        let personalData = currentPatient()?.personalData
        let address = personalData?.address ?? "—"
        
        return address
    }
    
    func getBirthDate() -> String {
        let personalData = currentPatient()?.personalData
        let birthDate = DateFormatterHelper.birthDateFormatter(from: personalData?.dateOfBirth)
        
        return birthDate
    }
    
    func getWeight() -> String {
        let personalData = currentPatient()?.personalData
        let weight = MedicalRecordFormatter.formatKg(personalData?.weight)
        
        return weight
    }
    
    func getHeight() -> String {
        let personalData = currentPatient()?.personalData
        let height = MedicalRecordFormatter.formatMeters(personalData?.height)
        
        return height
    }
    
    func getContacts() -> String {
        let personalData = currentPatient()?.personalData
        let contacts = MedicalRecordFormatter.contactsList(from: personalData?.contacts as? Set<Contact>)
        
        print(contacts)
        return contacts
    }

    // MARK: - HEALTH PROBLEMS
    
    private var currentHealthProblems: HealthProblems? {
        currentPatient()?.healthProblems
    }

    func getDiseasesText() -> String {
        let diseasesList = MedicalRecordFormatter.diseasesBulletList(
            from: currentHealthProblems?.diseases as? Set<Disease>
        )
        return diseasesList.isEmpty ? "—" : diseasesList
    }

    func getSurgeriesItems() -> [SurgeryDisplayItem] {
        surgeryDisplayItems = []

        let surgeriesSet = currentHealthProblems?.surgeries as? Set<Surgery> ?? []
        let sortedSurgeries = surgeriesSet.sorted { ($0.date ?? .distantPast) < ($1.date ?? .distantPast) }

        for surgery in sortedSurgeries {
            let name = surgery.name ?? "—"
            let dateString = surgery.date.map { DateFormatterHelper.birthDateFormatter(from: $0) } ?? "—"
            surgeryDisplayItems.append(
                .init(title: "Cirurgias", primary: name, secondary: dateString)
            )
        }

        return surgeryDisplayItems
    }

    func getSurgeriesText() -> String {
        let items = getSurgeriesItems()
        guard !items.isEmpty else { return "Sem registro" }
        return items
            .map { "\($0.primary)\n\($0.secondary)" }
            .joined(separator: "\n\n")
    }

    func getAllergiesText() -> String {
        currentHealthProblems?.allergies ?? "Sem registro"
    }

    func getObservationText() -> String {
        currentHealthProblems?.observation ?? "Sem registro"
    }

    // MARK: - PHYSICAL STATE

    private var currentPhysicalState: PhysicalState? {
        currentPatient()?.physicalState
    }

    func getVisionText() -> String {
        currentPhysicalState?.visionState
            .flatMap { VisionEnum(rawValue: $0)?.displayText } ?? "Sem registro"
    }

    func getHearingText() -> String {
        currentPhysicalState?.hearingState
            .flatMap { HearingEnum(rawValue: $0)?.displayText } ?? "Sem registro"
    }

    func getMobilityText() -> String {
        currentPhysicalState?.mobilityState
            .flatMap { MobilityEnum(rawValue: $0)?.displayText } ?? "Sem registro"
    }

    func getOralHealthText() -> String {
        currentPhysicalState?.oralHealthState
            .flatMap { OralHealthEnum(rawValue: $0)?.displayText } ?? "Sem registro"
    }
    
    // MARK: - MENTAL STATE

    private var currentMentalState: MentalState? {
        currentPatient()?.mentalState
    }

    func getEmotionalStateText() -> String {
        currentMentalState?.emotionalState
            .flatMap { EmotionalStateEnum(rawValue: $0)?.displayText } ?? "Sem registro"
    }

    func getOrientationStateText() -> String {
        currentMentalState?.orientationState
            .flatMap { OrientationEnum(rawValue: $0)?.displayText } ?? "Sem registro"
    }

    func getMemoryStateText() -> String {
        currentMentalState?.memoryState
            .flatMap { MemoryEnum(rawValue: $0)?.displayText } ?? "Sem registro"
    }
    
    // MARK: - PERSONAL CARE

    private var currentPersonalCare: PersonalCare? {
        currentPatient()?.personalCare
    }

    func getBathStateText() -> String {
        currentPersonalCare?.bathState
            .flatMap { BathEnum(rawValue: $0)?.displayText } ?? "Sem registro"
    }

    func getHygieneStateText() -> String {
        currentPersonalCare?.hygieneState
            .flatMap { HygieneEnum(rawValue: $0)?.displayText } ?? "Sem registro"
    }

    func getExcretionStateText() -> String {
        currentPersonalCare?.excretionState
            .flatMap { ExcretionEnum(rawValue: $0)?.displayText } ?? "Sem registro"
    }

    func getFeedingStateText() -> String {
        currentPersonalCare?.feedingState
            .flatMap { FeedingEnum(rawValue: $0)?.displayText } ?? "Sem registro"
    }

    func getEquipmentText() -> String {
        currentPersonalCare?.equipmentState ?? "Sem registro"
    }
    
    private func rebuildOutputs() {
        guard let person = currentPatient() else {
            completionPercentage = 0
            sections = []
            surgeryDisplayItems = []
            contactDisplayItems = []
            return
        }
        completionPercentage = calculateCompletion(for: person)
        sections = [
            .init(title: "Dados Pessoais", iconSystemName: "person.fill", rows: rowsPersonalData(from: person)),
            .init(title: "Problemas de Saúde", iconSystemName: "heart.fill", rows: rowsHealthProblems(from: person)),
            .init(title: "Estado Físico", iconSystemName: "figure", rows: rowsPhysicalState(from: person)),
            .init(title: "Estado Mental", iconSystemName: "brain.head.profile.fill", rows: rowsMentalState(from: person)),
            .init(title: "Cuidados Pessoais", iconSystemName: "hand.raised.fill", rows: rowsPersonalCare(from: person))
        ]
    }
    
    private func rowsPersonalData(from careRecipient: CareRecipient) -> [InformationRow] {
        let personalData = careRecipient.personalData
        let name = personalData?.name ?? "—"
        let address = personalData?.address ?? "—"
        let dateOfBirth = DateFormatterHelper.birthDateFormatter(from: personalData?.dateOfBirth)
        let weight = MedicalRecordFormatter.formatKg(personalData?.weight)
        let height = MedicalRecordFormatter.formatMeters(personalData?.height)

        contactDisplayItems = []
        if let contactsSet = personalData?.contacts as? Set<Contact>, !contactsSet.isEmpty {
            let ordered = contactsSet.sorted { (leftContact, rightContact) in
                let leftName = leftContact.name ?? ""
                let rightName = rightContact.name ?? ""
                return leftName.localizedCaseInsensitiveCompare(rightName) == .orderedAscending
            }
            for contact in ordered {
                let displayName = contact.name ?? "—"
                let relationshipText = contact.relationship
                let phoneText = contact.phone ?? "—"
                contactDisplayItems.append(
                    .init(name: displayName, relationship: relationshipText, phone: phoneText)
                )
            }
        }

        let contactsText: String = contactDisplayItems.isEmpty ? "—" : ""

        return [
            ("name".localized, name),
            ("birth_date".localized, dateOfBirth),
            ("weight".localized, weight),
            ("height".localized, height),
            ("address".localized, address),
            ("emergency_contact".localized, contactsText)
        ]
    }
    
    private func rowsHealthProblems(from careRecipient: CareRecipient) -> [InformationRow] {
        let healthProblems = careRecipient.healthProblems
        let diseasesList = MedicalRecordFormatter.diseasesBulletList(from: healthProblems?.diseases as? Set<Disease>)
        
        surgeryDisplayItems = []
        let surgeriesSet = healthProblems?.surgeries as? Set<Surgery> ?? []
        let sortedSurgeries = surgeriesSet
            .sorted { ($0.date ?? .distantPast) < ($1.date ?? .distantPast) }
        
        for surgery in sortedSurgeries {
            let name = surgery.name ?? "—"
            let dateString = surgery.date.map { DateFormatterHelper.birthDateFormatter(from: $0) } ?? "—"
            surgeryDisplayItems.append(.init(title: "Cirurgias", primary: name, secondary: dateString))
        }
        
        let surgeriesRow: InformationRow = surgeryDisplayItems.isEmpty ? ("Cirurgias", "—") : ("Cirurgias", "")
        
        let allergies = healthProblems?.allergies ?? "—"
        let observation = healthProblems?.observation ?? "—"
        return [
            ("Doenças", diseasesList),
            surgeriesRow,
            ("Alergias", allergies),
            ("observation".localized, observation)
        ]
    }
    
    private func rowsPhysicalState(from careRecipient: CareRecipient) -> [InformationRow] {
        let physicalState = careRecipient.physicalState
        let vision = physicalState?.visionState.flatMap { VisionEnum(rawValue: $0)?.displayText } ?? "—"
        let hearing = physicalState?.hearingState.flatMap { HearingEnum(rawValue: $0)?.displayText } ?? "—"
        let mobility = physicalState?.mobilityState.flatMap { MobilityEnum(rawValue: $0)?.displayText } ?? "—"
        let oralHealth = physicalState?.oralHealthState.flatMap { OralHealthEnum(rawValue: $0)?.displayText } ?? "—"
        return [
            ("Visão", vision),
            ("Audição", hearing),
            ("Locomoção", mobility),
            ("Saúde bucal", oralHealth)
        ]
    }
    
    private func rowsMentalState(from careRecipient: CareRecipient) -> [InformationRow] {
        let mentalState = careRecipient.mentalState
        let emotional = mentalState?.emotionalState.flatMap { EmotionalStateEnum(rawValue: $0)?.displayText } ?? "—"
        let orientation = mentalState?.orientationState.flatMap { OrientationEnum(rawValue: $0)?.displayText } ?? "—"
        let memory = mentalState?.memoryState.flatMap { MemoryEnum(rawValue: $0)?.displayText } ?? "—"
        return [
            ("Comportamento", emotional),
            ("Orientação", orientation),
            ("Memória", memory)
        ]
    }
    
    private func rowsPersonalCare(from careRecipient: CareRecipient) -> [InformationRow] {
        let personalCare = careRecipient.personalCare
        let bath = personalCare?.bathState.flatMap { BathEnum(rawValue: $0)?.displayText } ?? "—"
        let hygiene = personalCare?.hygieneState.flatMap { HygieneEnum(rawValue: $0)?.displayText } ?? "—"
        let excretion = personalCare?.excretionState.flatMap { ExcretionEnum(rawValue: $0)?.displayText } ?? "—"
        let feeding = personalCare?.feedingState.flatMap { FeedingEnum(rawValue: $0)?.displayText } ?? "—"
        let equipment = personalCare?.equipmentState ?? "—"
        return [
            ("Banho", bath),
            ("Higiene", hygiene),
            ("Excreção", excretion),
            ("feeding".localized, feeding),
            ("Equipamentos", equipment)
        ]
    }
    
    private func calculateCompletion(for careRecipient: CareRecipient) -> CGFloat {
        var totalFields = 0
        var filledFields = 0
        func checkString(_ value: String?) {
            totalFields += 1
            if let text = value, !text.trimmingCharacters(in: .whitespaces).isEmpty { filledFields += 1 }
        }
        func checkDate(_ value: Date?) {
            totalFields += 1
            if value != nil { filledFields += 1 }
        }
        func checkDouble(_ value: Double?) {
            totalFields += 1
            if let number = value, !number.isNaN { filledFields += 1 }
        }
        func checkArray(_ value: Any?) {
            totalFields += 1
            if let array = value as? [Any], !array.isEmpty { filledFields += 1 }
        }
        func checkToManySet<T>(_ value: Set<T>?) {
            totalFields += 1
            if let set = value, !set.isEmpty { filledFields += 1 }
        }
        
        let personalData = careRecipient.personalData
        checkString(personalData?.name)
        checkString(personalData?.address)
        checkString(personalData?.gender)
        checkDate(personalData?.dateOfBirth)
        checkDouble(personalData?.height)
        checkDouble(personalData?.weight)
        
        let healthProblems = careRecipient.healthProblems
        checkString(healthProblems?.observation)
        checkString(healthProblems?.allergies)
        
        let mentalState = careRecipient.mentalState
        checkString(mentalState?.cognitionState)
        checkString(mentalState?.emotionalState)
        checkString(mentalState?.memoryState)
        checkString(mentalState?.orientationState)
        
        let physicalState = careRecipient.physicalState
        checkString(physicalState?.mobilityState)
        checkString(physicalState?.hearingState)
        checkString(physicalState?.visionState)
        checkString(physicalState?.oralHealthState)
        
        let personalCare = careRecipient.personalCare
        checkString(personalCare?.bathState)
        checkString(personalCare?.hygieneState)
        checkString(personalCare?.excretionState)
        checkString(personalCare?.feedingState)
        checkString(personalCare?.equipmentState)
        
        guard totalFields > 0 else { return 0.0 }
        return CGFloat(Double(filledFields) / Double(totalFields))
    }
}
