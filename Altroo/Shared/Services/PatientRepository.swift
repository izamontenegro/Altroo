//
//  PatientRepository.swift
//  Altroo
//
//  Created by Layza Maria Rodrigues Carneiro on 08/10/25.
//

final class PatientRepository {
    private let coreDataService: CoreDataService
    
    init(coreDataService: CoreDataService = CoreDataService()) {
        self.coreDataService = coreDataService
    }
    
    func fetchAllPatients() -> [CareRecipient] {
        coreDataService.fetchAllCareRecipients()
    }
    
    func deletePatient(_ patient: CareRecipient) {
        coreDataService.deleteCareRecipient(patient)
    }
    
    func saveChanges() {
        coreDataService.save()
    }
}
