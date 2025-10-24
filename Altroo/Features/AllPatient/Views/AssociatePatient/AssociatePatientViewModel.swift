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

    var allPatients: [CareRecipient] {
        userService.fetchPatients()
    }
    
    func setCurrentPatient(_ careRecipient: CareRecipient) {
        userService.setCurrentPatient(careRecipient)
    }
}
