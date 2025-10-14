//
//  ChangeCareRecipientViewModel.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 13/10/25.
//

import UIKit
import Combine

final class ChangeCareRecipientViewModel {
    var userService: UserServiceProtocol
    var coreDataService: CoreDataService
    
    init(userService: UserServiceProtocol, coreDataService: CoreDataService) {
        self.userService = userService
        self.coreDataService = coreDataService
    }
    
    func changeCurrentCareRecipient(newCurrentPatient: CareRecipient) {
        userService.setCurrentPatient(newCurrentPatient)
    }
    
    func fetchAvailableCareRecipients() -> [CareRecipient] {
        let all = userService.fetchPatients()
        return all
    }
}
