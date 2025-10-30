//
//  CareRecipientProfileViewModel.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 13/10/25.
//

import UIKit
import Combine
import CloudKit
import CoreData

final class CareRecipientProfileViewModel {
    var userService: UserServiceProtocol
    var coreDataService: CoreDataService
    
    @Published private(set) var completionPercent: CGFloat = 8.0
    
    init(userService: UserServiceProtocol, coreDataService: CoreDataService) {
        self.userService = userService
        self.coreDataService = coreDataService
    }
    
    func buildData() {
        completionPercent = calcCompletion()
    }
    
    func currentCareRecipient() -> CareRecipient? {
        userService.fetchCurrentPatient()
    }
    
    func finishCare() {
        guard let recipient = currentCareRecipient() else { return }
        coreDataService.deleteCareRecipient(recipient)
    }
    
    func caregiversForCurrentRecipient() -> [ParticipantsAccess] {
        guard let recipient = currentCareRecipient() else { return []}
        return coreDataService.participantsWithCategory(for: recipient)
    }
    
    func currentShare() -> CKShare? {
        guard let recipient = currentCareRecipient() else { return nil }
        return coreDataService.stack.getShare(recipient)
    }
    
    private func calcCompletion() -> CGFloat {
        guard let person = currentCareRecipient() else {
            completionPercent = 0
            return 0.0
        }
        let recipient = person
        var total = 0, filled = 0
        func checkString(_ v: String?) { total += 1; if let x = v, !x.trimmingCharacters(in: .whitespaces).isEmpty { filled += 1 } }
        func checkDate(_ v: Date?) { total += 1; if v != nil { filled += 1 } }
        func checkDouble(_ v: Double?) { total += 1; if let x = v, !x.isNaN { filled += 1 } }
        func checkArray(_ v: Any?) { total += 1; if let a = v as? [Any], !a.isEmpty { filled += 1 } }

        let personalData = recipient.personalData
        checkString(personalData?.name); checkString(personalData?.address); checkString(personalData?.gender)
        checkDate(personalData?.dateOfBirth); checkDouble(personalData?.height); checkDouble(personalData?.weight)

        let healthProblems = recipient.healthProblems
        checkString(healthProblems?.observation); checkArray(healthProblems?.allergies); checkArray(healthProblems?.surgery)

        let mentalState = recipient.mentalState
        checkString(mentalState?.cognitionState); checkString(mentalState?.emotionalState); checkString(mentalState?.memoryState); checkString(mentalState?.orientationState)

        let physicalState = recipient.physicalState
        checkString(physicalState?.mobilityState); checkString(physicalState?.hearingState); checkString(physicalState?.visionState); checkString(physicalState?.oralHealthState)

        let personalCare = recipient.personalCare
        checkString(personalCare?.bathState); checkString(personalCare?.hygieneState); checkString(personalCare?.excretionState); checkString(personalCare?.feedingState); checkString(personalCare?.equipmentState)

        guard total > 0 else { return 0.0 }
        return CGFloat(Double(filled) / Double(total))
    }
    
    func updatePermission(for participant: CKShare.Participant,
                          of object: NSManagedObject,
                          to newPermission: CKShare.ParticipantPermission,
                          completion: @escaping (Result<Void, Error>) -> Void) {
        coreDataService.updateParticipantPermission(for: object, participant: participant, to: newPermission, completion: completion)
    }
}

