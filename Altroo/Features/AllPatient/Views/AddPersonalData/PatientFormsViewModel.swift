//
//  PatientFormsViewModel.swift
//  Altroo
//
//  Created by Layza Maria Rodrigues Carneiro on 08/10/25.
//

import Foundation

class BasicNeedsFacadeMock: BasicNeedsFacadeProtocol {}
class RoutineActivitiesFacadeMock: RoutineActivitiesFacadeProtocol {}

final class PatientFormsViewModel {
    
    var careRecipientFacade: CareRecipientFacade
    
    var newPatient: CareRecipient?

    init(careRecipientFacade: CareRecipientFacade) {
        self.careRecipientFacade = careRecipientFacade
    }

    
    func createNewPatient(name: String, gender: String, dateOfBirth: Date, height: Double, weight: Double) {
        newPatient = careRecipientFacade.buildCareRecipient { personalData, personalCare, healthProblems, mentalState, physicalState, routineActivities, basicNeeds, careRecipientEvent, symptom in
            careRecipientFacade.addName(name: name, in: personalData)
            careRecipientFacade.addGender(gender: gender, in: personalData)
            careRecipientFacade.addDateOfBirth(birthDate: dateOfBirth, in: personalData)
            careRecipientFacade.addHeight(height: height, in: personalData)
            careRecipientFacade.addWeight(weight: weight, in: personalData)
        }
    }
    
}
