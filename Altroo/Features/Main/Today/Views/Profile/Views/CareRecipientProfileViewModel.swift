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
    
    init(userService: UserServiceProtocol, coreDataService: CoreDataService) {
        self.userService = userService
        self.coreDataService = coreDataService
    }
    
    func currentCareRecipient() -> CareRecipient? {
        userService.fetchCurrentPatient()
    }
    
    func finishCare() {
        guard let r = currentCareRecipient() else { return }
        coreDataService.deleteCareRecipient(r)
    }
    
    func caregiversForCurrentRecipient() -> [ParticipantsAccess] {
        guard let r = currentCareRecipient() else { return [] }
        return coreDataService.participantsWithCategory(for: r)
    }
    
    func currentShare() -> CKShare? {
        guard let r = currentCareRecipient() else { return nil }
        return coreDataService.getShare(r)
    }
}
