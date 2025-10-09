//
//  ComorbiditiesViewModel.swift
//  Altroo
//
//  Created by Layza Maria Rodrigues Carneiro on 09/10/25.
//

final class ComorbiditiesViewModel {
    private let patientService: PatientService
    private let patientRepository = PatientRepository()

    init(patientService: PatientService) {
        self.patientService = patientService
//        self.patientRepository = patientRepository
    }

    var hasActivePatient: Bool {
        patientService.hasPatient
    }
    
    var allPatients: [CareRecipient] {
        patientRepository.fetchAllPatients()
    }
}
