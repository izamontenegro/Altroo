//
//  EditSymptomViewModel.swift
//  Altroo
//
//  Created by Raissa Parente on 14/10/25.
//
import Foundation
import Combine

class EditSymptomViewModel {
    let careRecipientFacade: CareRecipientFacade
    let userService: UserServiceProtocol
    var symptom: Symptom
    
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
    
    init(careRecipientFacade: CareRecipientFacade, userService: UserServiceProtocol, symptom: Symptom) {
        self.careRecipientFacade = careRecipientFacade
        self.symptom = symptom
        self.userService = userService
        
        updateFields()
        fetchCareRecipient()
    }
    
    private func updateFields() {
        name = symptom.name!
        date = symptom.date ?? .now
        time = symptom.date ?? .now
        note = symptom.symptomDescription ?? ""
    }
    
    private func fetchCareRecipient() {
        currentCareRecipient = userService.fetchCurrentPatient()
    }
    
    func updateSymptom() -> Bool {
        guard validator.isEmpty(name, error: &nameError) else { return false }
        guard validator.checkFutureDate(fullDate, error: &dateError) else { return false }
        
        careRecipientFacade.editSymptom(symptom: symptom, name: name, symptomDescription: note, date: fullDate)
        
        return true
    }
    
    func deleteSymptom() {
        careRecipientFacade.deleteSymptom(symptomRecord: symptom, from: currentCareRecipient!)
    }
}

