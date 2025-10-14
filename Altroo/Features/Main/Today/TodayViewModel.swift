//
//  TodayViewModel.swift
//  Altroo
//
//  Created by Raissa Parente on 13/10/25.
//
import Combine

class TodayViewModel {
    let careRecipientFacade: CareRecipientFacade
    var currentCareRecipient: CareRecipient?
    
    @Published var todaySymptoms: [Symptom] = []
    
    init(careRecipientFacade: CareRecipientFacade) {
        self.careRecipientFacade = careRecipientFacade
        
        //FIXME: Change to real patient
        self.currentCareRecipient = CoreDataService(stack: CoreDataStack.shared)
            .fetchAllCareRecipients()
            .first(where: { $0.personalData?.name == "Mrs. Parente" })!
        
        fetchAllTodaySymptoms()
    }
    
    func fetchAllTodaySymptoms() {
        todaySymptoms = careRecipientFacade.fetchAllSymptoms(from: currentCareRecipient!)
    }
    
}
