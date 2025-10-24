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
    @Published var nameError: String?
    @Published var time: Date = .now
    @Published var date: Date = .now
    @Published var dateError: String?

    @Published var note: String = ""
    
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
    
    
    func createSymptom() -> Bool {
        guard let careRecipient = currentCareRecipient else { return false }
        guard validator.isEmpty(name, fieldName: "Nome", error: &nameError) else { return false }
        guard validator.checkFutureDate(fullDate, error: &dateError) else { return false }
        
       
        let author = coreDataService.currentPerformerName(for: careRecipient)
        
        careRecipientFacade.addSymptom(name: name, symptomDescription: note, date: fullDate, in: careRecipient)
        
        
        historyService.addHistoryItem(title: "Registrou \(name)", author: author, date: Date(), to: careRecipient)
        
        
        return true
    }
}
