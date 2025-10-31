//
//  EditMedicalRecordViewModel.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 29/10/25.
//
import Combine
import CloudKit
import CoreData

final class EditMedicalRecordViewModel {
    var userService: UserServiceProtocol
    let careRecipientFacade: CareRecipientFacade
    
    @Published var personalDataFormState = PersonalDataFormState()
    @Published var physicalStateFormState = PhysicalStateFormState()
    @Published var mentalStateFormState = MentalStateFormState()
    @Published var personalCareFormState = PersonalCareFormState()

    init(userService: UserServiceProtocol, careRecipientFacade: CareRecipientFacade) {
        self.userService = userService
        self.careRecipientFacade = careRecipientFacade
    }
    
    func currentPatient() -> CareRecipient? {
        userService.fetchCurrentPatient()
    }
}

extension EditMedicalRecordViewModel {
    func persistFormState() {
        persistPersonalDataFormState()
        persistPhysicalStateFormState()
        persistMentalStateFormState()
        persistPersonalCareFormState()
    }
}
