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
        guard let r = currentCareRecipient() else { return }
        coreDataService.deleteCareRecipient(r)
    }
    
    func caregiversForCurrentRecipient() -> [ParticipantsAccess] {
        guard let r = currentCareRecipient() else { return []}
        return coreDataService.participantsWithCategory(for: r)
    }
    
    func currentShare() -> CKShare? {
        guard let r = currentCareRecipient() else { return nil }
        return coreDataService.getShare(r)
    }
    
    private func calcCompletion() -> CGFloat {
        guard let person = currentCareRecipient() else {
            print("nao tem carereficinet")
            completionPercent = 0
            return 0.0
        }
        let r = person
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
    
    func updatePermission(for participant: CKShare.Participant,
                          of object: NSManagedObject,
                          to newPermission: CKShare.ParticipantPermission,
                          completion: @escaping (Result<Void, Error>) -> Void) {
        coreDataService.updateParticipantPermission(for: object, participant: participant, to: newPermission, completion: completion)
    }
}

