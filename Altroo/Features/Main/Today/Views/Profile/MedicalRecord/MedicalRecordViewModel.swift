//
//  MedicalRecordSectionVM.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 12/10/25.
//
import UIKit
import Combine

public typealias InformationRow = (title: String, value: String)

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
    
    @Published private(set) var completionPercentage: CGFloat = 0.0
    @Published private(set) var reloadToken: Int = 0
    
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
        return DateFormatterHelper.fullDateFormaterr(from: person.recordUpdatedAt)
    }
    
    // MARK: - PERSONAL DATA
    
    func getName() -> String {
        let personalData = currentPatient()?.personalData
        return personalData?.name ?? "Sem registro"
    }
    
    func getAddress() -> String {
        let personalData = currentPatient()?.personalData
        return personalData?.address ?? "—"
    }
    
    func getBirthDate() -> String {
        let personalData = currentPatient()?.personalData
        return DateFormatterHelper.birthDateFormatter(from: personalData?.dateOfBirth)
    }
    
    func getWeight() -> String {
        let personalData = currentPatient()?.personalData
        return MedicalRecordFormatter.formatKg(personalData?.weight)
    }
    
    func getHeight() -> String {
        let personalData = currentPatient()?.personalData
        return MedicalRecordFormatter.formatMeters(personalData?.height)
    }
    
    func getContacts() -> String {
        let personalData = currentPatient()?.personalData
        let contacts = MedicalRecordFormatter.contactsList(from: personalData?.contacts as? Set<Contact>)
        return contacts
    }
    
    func getContactDisplayItem() -> ContactDisplayItem? {
        guard
            let personalData = currentPatient()?.personalData,
            let contactsSet = personalData.contacts as? Set<Contact>,
            let contact = contactsSet.first
        else {
            return nil
        }
        
        return ContactDisplayItem(
            name: contact.name ?? "Sem nome",
            relationship: contact.relationship,
            phone: contact.phone ?? ""
        )
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
        let surgeriesSet = currentHealthProblems?.surgeries as? Set<Surgery> ?? []
        if surgeriesSet.isEmpty { return [] }
        
        let sorted = surgeriesSet.sorted { ($0.date ?? .distantPast) < ($1.date ?? .distantPast) }
        
        return sorted.map { surgery in
            let name = surgery.name ?? "—"
            let dateString = surgery.date
                .map { DateFormatterHelper.birthDateFormatter(from: $0) } ?? "—"
            return SurgeryDisplayItem(
                title: "Cirurgias",
                primary: name,
                secondary: dateString
            )
        }
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
        guard
            let rawValues = currentPhysicalState?.oralHealthState,
            !rawValues.isEmpty
        else { return "Sem registro" }

        let items = rawValues.compactMap { OralHealthEnum(rawValue: $0)?.displayText }
        return items.isEmpty ? "Sem registro" : items.joined(separator: ", ")
    }
    
    // MARK: - MENTAL STATE

    private var currentMentalState: MentalState? {
        currentPatient()?.mentalState
    }

    func getEmotionalStateText() -> String {
        guard
            let rawValues = currentMentalState?.emotionalState,
            !rawValues.isEmpty
        else { return "Sem registro" }

        let items = rawValues.compactMap { EmotionalStateEnum(rawValue: $0)?.displayText }
        return items.joined(separator: ", ")
    }
    
    
    func getOrientationStateText() -> String {
        guard
            let rawValues = currentMentalState?.orientationState,
            !rawValues.isEmpty
        else { return "Sem registro" }

        let items = rawValues.compactMap { OrientationEnum(rawValue: $0)?.displayText }
        return items.isEmpty ? "Sem registro" : items.joined(separator: ", ")
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
    
    // MARK: - Rebuild / completion

    private func rebuildOutputs() {
        guard let person = currentPatient() else {
            completionPercentage = 0
            reloadToken &+= 1
            return
        }
        completionPercentage = calculateCompletion(for: person)
        reloadToken &+= 1
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
        
        let mentalState = careRecipient.mentalState
        checkToManySet(Set(mentalState?.emotionalState ?? []))
        checkString(mentalState?.memoryState)
        checkToManySet(Set(mentalState?.orientationState ?? [] ))
        
        let physicalState = careRecipient.physicalState
        checkString(physicalState?.mobilityState)
        checkString(physicalState?.hearingState)
        checkString(physicalState?.visionState)
        checkToManySet(Set(physicalState?.oralHealthState ?? []))
        
        let personalCare = careRecipient.personalCare
        checkString(personalCare?.bathState)
        checkString(personalCare?.hygieneState)
        checkString(personalCare?.excretionState)
        checkString(personalCare?.feedingState)
        
        guard totalFields > 0 else { return 0.0 }
        return CGFloat(Double(filledFields) / Double(totalFields))
    }
}
