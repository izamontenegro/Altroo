//
//  AssociatePatientViewModel.swift
//  Altroo
//
//  Created by Layza Maria Rodrigues Carneiro on 08/10/25.
//

final class AssociatePatientViewModel {
    private var userService: UserServiceProtocol

    init(userService: UserServiceProtocol) {
        self.userService = userService
    }
    
    func fetchAvailableCareRecipients() -> [CareRecipient] {
        let all = userService.fetchPatients()
        return all
    }
    
    func setCurrentPatient(_ careRecipient: CareRecipient) {
        userService.setCurrentPatient(careRecipient)
    }
}
