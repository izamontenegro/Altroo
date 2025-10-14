//
//  AddSymptomViewModel.swift
//  Altroo
//
//  Created by Raissa Parente on 13/10/25.
//
import Foundation
import Combine

class AddSymptomViewModel {
    let careRecipientFacade: CareRecipientFacade
    var currentCareRecipient: CareRecipient?
    
    @Published var name: String = ""
    @Published var time: Date = .now
    @Published var date: Date = .now
    @Published var note: String = ""
    
    var fullDate: Date {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.day, .month, .year], from: date)
        let time = calendar.dateComponents([.hour, .minute], from: time)
        components.hour = time.hour
        components.minute = time.minute
        let newDate = calendar.date(from: components) ?? .now
        
        return newDate
    }
    
    init(careRecipientFacade: CareRecipientFacade) {
        self.careRecipientFacade = careRecipientFacade
        
        //FIXME: Change to real patient
        self.currentCareRecipient = CoreDataService(stack: CoreDataStack.shared)
            .fetchAllCareRecipients()
            .first(where: { $0.personalData?.name == "Mrs. Parente" })!
    }

    
    func createSymptom() {
        print("Symptoms on record before add: \(careRecipientFacade.fetchAllSymptoms(from: currentCareRecipient!).count)")
        
        careRecipientFacade.addSymptom(name: name, symptomDescription: note, date: fullDate, in: currentCareRecipient!)
        
        print("Symptoms on record after add: \(careRecipientFacade.fetchAllSymptoms(from: currentCareRecipient!).count)")
    }
}
