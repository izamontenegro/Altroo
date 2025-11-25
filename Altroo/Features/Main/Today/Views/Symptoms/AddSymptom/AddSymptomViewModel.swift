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
    
    let mode: Mode
    
    var currentCareRecipient: CareRecipient?
    
    @Published var name: String = ""
    @Published var time: Date = .now
    @Published var date: Date = .now
    @Published var note: String = ""
    @Published var selectedSymptom: SymptomExample?
    
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
    
    init(careRecipientFacade: CareRecipientFacade, userService: UserServiceProtocol, coreDataService: CoreDataService, mode: Mode) {
        self.careRecipientFacade = careRecipientFacade
        self.userService = userService
        self.coreDataService = coreDataService
        self.mode = mode
        
        fetchCareRecipient()
        
        if case .edit(let existing) = mode {
            if let example = SymptomExample.allCases.first(where: { $0.displayText == existing.name }) {
                    self.selectedSymptom = example
                    self.name = example.displayText
                } else {
                    self.selectedSymptom = nil
                    self.name = existing.name ?? ""
                }
            self.note = existing.symptomDescription ?? ""
            self.date = existing.date ?? .now
            self.time = existing.date ?? .now
        }
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
        
        switch mode {
        case .create:
            let author = coreDataService.currentPerformerName(for: careRecipient)
            careRecipientFacade.addSymptom(name: name, symptomDescription: note, date: fullDate, author: author, in: careRecipient)
            
        case .edit(let existing):
            careRecipientFacade.editSymptom(symptom: existing, name: name, symptomDescription: note, date: fullDate)
        }
    }
    
    func deleteSymptom() {
        switch mode {
        case .create:
            break
        case .edit(let existing):
            careRecipientFacade.deleteSymptom(symptomRecord: existing, from: currentCareRecipient!)
        }
    }
}
