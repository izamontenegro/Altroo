//
//  TodayViewModel.swift
//  Altroo
//
//  Created by Raissa Parente on 13/10/25.
//
import Combine

class TodayViewModel {
    let careRecipientFacade: CareRecipientFacade
    let userService: UserServiceProtocol

    var currentCareRecipient: CareRecipient?
    
    @Published var todaySymptoms: [Symptom] = []
    
    init(careRecipientFacade: CareRecipientFacade, userService: UserServiceProtocol) {
        self.careRecipientFacade = careRecipientFacade
        self.userService = userService
        
        fetchCareRecipient()
        fetchAllTodaySymptoms()
    }
    
    private func fetchCareRecipient() {
        currentCareRecipient = userService.fetchCurrentPatient()
    }
    
    func fetchAllTodaySymptoms() {
        todaySymptoms = careRecipientFacade.fetchAllSymptomForDate(.now, from: currentCareRecipient!)
    }
    
}
