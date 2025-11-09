//
//  AssociatePatientViewModel.swift
//  Altroo
//
//  Created by Layza Maria Rodrigues Carneiro on 08/10/25.
//

import Combine

final class AssociatePatientViewModel {
    private var userService: UserServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    @Published private(set) var careRecipients: [CareRecipient] = []
    @Published private(set) var currentCareRecipient: CareRecipient?
    

    init(userService: UserServiceProtocol) {
        self.userService = userService
        
        refreshData()
        
        userService.cloudKitDidChangePublisher
            .sink { [weak self] in
                self?.refreshData()
            }
            .store(in: &cancellables)
    }
    
    func refreshData() {
        careRecipients = userService.fetchPatients()
        currentCareRecipient = userService.fetchCurrentPatient()
    }
    
    func fetchAvailableCareRecipients() -> [CareRecipient] {
        let all = userService.fetchPatients()
        return all
    }
    
    func setCurrentCareRecipient(_ careRecipient: CareRecipient) {
        userService.setCurrentPatient(careRecipient)
        refreshData()
    }
    
    func getCurrentCareRecipient() -> CareRecipient? {
        return userService.fetchCurrentPatient()
    }
}
