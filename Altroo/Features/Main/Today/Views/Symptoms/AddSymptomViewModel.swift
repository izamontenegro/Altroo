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
    let userService: UserServiceProtocol
    let coreDataService: CoreDataService
    let historyService: HistoryService
    
    var currentCareRecipient: CareRecipient?
    
    @Published var name: String = ""
    @Published var time: Date = .now
    @Published var date: Date = .now

    @Published var note: String = ""
    
    @Published private(set) var fieldErrors: [String: String] = [:]
    private let validator = FormValidator()
    
    var fullDate: Date {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.day, .month, .year], from: date)
        let time = calendar.dateComponents([.hour, .minute], from: time)
        components.hour = time.hour
        components.minute = time.minute
        let newDate = calendar.date(from: components) ?? .now
        
        return newDate
    }
    
    init(careRecipientFacade: CareRecipientFacade, userService: UserServiceProtocol, coreDataService: CoreDataService, historyService: HistoryService) {
        self.careRecipientFacade = careRecipientFacade
        self.userService = userService
        self.coreDataService = coreDataService
        self.historyService = historyService
        
        fetchCareRecipient()
    }
    
    func fetchCareRecipient() {
        currentCareRecipient = userService.fetchCurrentPatient()
    }
    
    func validateSymptom() -> Bool {
        var newErrors: [String: String] = [:]

       _ = validator.isEmpty(name, error: &newErrors["name"])
       _ = validator.checkFutureDate(fullDate, error: &newErrors["date"])
        
        fieldErrors = newErrors

        return newErrors.isEmpty
    }
    
    func createSymptom()  {
        guard let careRecipient = currentCareRecipient else { return }
       
        let author = coreDataService.currentPerformerName(for: careRecipient)
        
        careRecipientFacade.addSymptom(name: name, symptomDescription: note, date: fullDate, author: author, in: careRecipient)
        
        historyService.addHistoryItem(title: "Registrou \(name)", author: author, date: Date(), type: .symptom, to: careRecipient)
    }
}
