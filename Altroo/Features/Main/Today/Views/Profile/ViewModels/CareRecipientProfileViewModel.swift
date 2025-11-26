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
    
    @Published private(set) var currentCareRecipient: CareRecipient?
    @Published private(set) var caregivers: [ParticipantsAccess] = []
    @Published private(set) var completionPercent: CGFloat = 8.0
    
    private var cancellables = Set<AnyCancellable>()
    
    init(userService: UserServiceProtocol, coreDataService: CoreDataService) {
        self.userService = userService
        self.coreDataService = coreDataService
        
        self.currentCareRecipient = userService.fetchCurrentPatient()
        self.caregivers = caregiversFor(recipient: currentCareRecipient)
        self.completionPercent = calcCompletion(for: currentCareRecipient)
        
        setupCloudKitObservers()
    }
    
    func buildData() {
        loadCurrentRecipient()
        loadCaregivers()
        completionPercent = calcCompletion(for: currentCareRecipient)
    }
    
    func finishCare() {
        guard let recipient = currentCareRecipient else { return }
        
        if coreDataService.isOwner(object: recipient) {
            coreDataService.deleteCareRecipient(recipient)
        } else {
            userService.removePatient(recipient)
            userService.removeCurrentPatient()
//            coreDataService.removeParticipant(
//                participant,
//                from: parentObject
//            ) { result in
//                DispatchQueue.main.async {
//                    switch result {
//                    case .success:
//                        print("Caregiver removed.")
//                    case .failure(let error):
//                        print("Error removing caregiver:", error)
//                    }
//                }
//            }
        }
        
        buildData()
    }
    
    func caregiversFor(recipient: CareRecipient?) -> [ParticipantsAccess] {
        guard let recipient else { return [] }
        return coreDataService.participantsWithCategory(for: recipient)
    }
    
    func currentShare() -> CKShare? {
        guard let recipient = currentCareRecipient else { return nil }
        return coreDataService.getShare(recipient)
    }
    
    private func calcCompletion(for recipient: CareRecipient?) -> CGFloat {
        guard let recipient else { return 0.0 }
        var total = 0, filled = 0
        func checkString(_ v: String?) { total += 1; if let x = v, !x.trimmingCharacters(in: .whitespaces).isEmpty { filled += 1 } }
        func checkDate(_ v: Date?) { total += 1; if v != nil { filled += 1 } }
        func checkDouble(_ v: Double?) { total += 1; if let x = v, !x.isNaN { filled += 1 } }
        func checkArray(_ v: Any?) { total += 1; if let a = v as? [Any], !a.isEmpty { filled += 1 } }
        func checkToManySet<T>(_ v: Set<T>?) { total += 1; if let set = v, !set.isEmpty { filled += 1 } }

        let personalData = recipient.personalData
        checkString(personalData?.name); checkString(personalData?.address); checkString(personalData?.gender)
        checkDate(personalData?.dateOfBirth); checkDouble(personalData?.height); checkDouble(personalData?.weight)

        let mentalState = recipient.mentalState
        checkToManySet(Set(mentalState?.emotionalState ?? [])); checkString(mentalState?.memoryState); checkToManySet(Set(mentalState?.orientationState ?? []))

        let physicalState = recipient.physicalState
        checkString(physicalState?.mobilityState); checkString(physicalState?.hearingState); checkString(physicalState?.visionState); checkToManySet(Set(physicalState?.oralHealthState ?? []))

        let personalCare = recipient.personalCare
        checkString(personalCare?.bathState); checkString(personalCare?.hygieneState); checkString(personalCare?.excretionState); checkString(personalCare?.feedingState);

        guard total > 0 else { return 0.0 }
        return CGFloat(Double(filled) / Double(total))
    }
    
    func updatePermission(for participant: CKShare.Participant,
                          of object: NSManagedObject,
                          to newPermission: CKShare.ParticipantPermission,
                          completion: @escaping (Result<Void, Error>) -> Void) {
        coreDataService.updateParticipantPermission(for: object, participant: participant, to: newPermission, completion: completion)
    }
    
    func getCurrentCareRecipientName() -> String {
        currentCareRecipient?.personalData?.name ?? ""
    }
    
    func loadCurrentRecipient() {
        currentCareRecipient = userService.fetchCurrentPatient()
    }

    func loadCaregivers() {
        guard let r = currentCareRecipient else {
            caregivers = []
            return
        }
        caregivers = coreDataService.participantsWithCategory(for: r)
    }
    
    private func setupCloudKitObservers() {
        NotificationCenter.default.publisher(for: .didFinishCloudKitSync)
            .merge(with:
                NotificationCenter.default.publisher(for: .sharedStoreDidSync),
                NotificationCenter.default.publisher(for: .privateStoreDidSync)
            )
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.buildData()
            }
            .store(in: &cancellables)
    }
}
