//
//  EditMedicalRecordViewModel.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 29/10/25.
//
import Combine
import CloudKit
import CoreData

struct DiseaseFormState: Equatable {
    var diseasesText: String = ""
}

final class EditMedicalRecordViewModel {
    var userService: UserServiceProtocol
    let careRecipientFacade: CareRecipientFacade
    
    let relationshipOptions = ["Cuidador", "Mãe/Pai", "Filha/Filho", "Neta/Neto", "Familiar", "Amigo", "Outro"]
        @Published var selectedContactRelationship: String = "Filha/Filho"

        @Published var personalDataFormState = PersonalDataFormState()
        @Published var fieldErrors: [String: String] = [:]

    @Published var healthFormState = HealthProblemsFormState()
    @Published var diseaseFormState = DiseaseFormState()

    
    @Published var physicalStateFormState = PhysicalStateFormState()
    @Published var mentalStateFormState = MentalStateFormState()
    @Published var personalCareFormState = PersonalCareFormState()
    
    let validator = FormValidator()

    init(userService: UserServiceProtocol, careRecipientFacade: CareRecipientFacade) {
        self.userService = userService
        self.careRecipientFacade = careRecipientFacade
    }
    
    func currentPatient() -> CareRecipient? {
        userService.fetchCurrentPatient()
    }
    
    func validateEditProfile() -> Bool {
        return validatePersonalData()
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
