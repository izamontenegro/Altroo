//
//  UserServiceSession.swift
//  Altroo
//
//  Created by Layza Maria Rodrigues Carneiro on 11/10/25.
//

import CoreData
import UIKit
import Combine

class UserServiceSession: UserServiceProtocol {
    
    private let context: NSManagedObjectContext
    private let cloudKitChangeSubject = PassthroughSubject<Void, Never>()

    @Published private var currentPatient: CareRecipient?
    
    var currentPatientPublisher: AnyPublisher<CareRecipient?, Never> {
        return $currentPatient.eraseToAnyPublisher()
    }
    
    var cloudKitDidChangePublisher: AnyPublisher<Void, Never> {
        cloudKitChangeSubject.eraseToAnyPublisher()
    }

    func handleCloudKitChange() {
        cloudKitChangeSubject.send()
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
        if let saved = fetchCurrentPatientFromStorage() {
            self.currentPatient = saved
        }
    }

    private func fetchCurrentPatientFromStorage() -> CareRecipient? {
        guard let user = fetchUser(),
              let id = user.activeCareRecipient else { return nil }
        return fetchCareRecipient(id: id)
    }

    func fetchUser() -> User? {
        let request = User.fetchRequest()
        request.fetchLimit = 1
        return try? context.fetch(request).first
    }
    
    func createUser(name: String, category: String) -> User {
        let user = User(context: context)
        user.name = name
        user.category = category
        try? context.save()
        return user
    }
    
    func setName(_ name: String) {
        guard let user = fetchUser() else { return }
        user.name = name
        save()
    }
    
    func setCategory(_ category: String) {
        guard let user = fetchUser() else { return }
        user.category = category
        save()
    }
    
    func setCurrentPatient(_ patient: CareRecipient) {
        currentPatient = patient
        if let user = fetchUser(), let id = patient.id {
            user.activeCareRecipient = id
            save()
        }
    }
    
    func addPatient(_ patient: CareRecipient) {
        guard let user = fetchUser() else { return }
        
        if user.careRecipient == nil {
            user.careRecipient = []
        }

        if let id = patient.id, !(user.careRecipient?.contains(id) ?? false) {
            user.careRecipient?.append(id)
            save()
        } else {
            print("Patient already added or invalid ID")
        }
    }
    
    func removePatient(_ patient: CareRecipient) {
        guard let user = fetchUser(),
              var ids = user.careRecipient,
              let id = patient.id
        else { return }

        if let index = ids.firstIndex(of: id) {
            ids.remove(at: index)
            user.careRecipient = ids
            save()
        }
    }

    
    func fetchCareRecipient(id: UUID) -> CareRecipient? {
        let context = CoreDataStack.shared.context
        let request: NSFetchRequest<CareRecipient> = CareRecipient.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)

        let coordinator = context.persistentStoreCoordinator

        if let result = try? context.fetch(request).first, result != nil {
            return result
        }

        request.affectedStores = coordinator?.persistentStores
        return try? context.fetch(request).first
    }

    
    func fetchCurrentPatient() -> CareRecipient? {
        return currentPatient
    }

    func fetchPatients() -> [CareRecipient] {
        guard
            let user = fetchUser(),
            let ids = user.careRecipient
        else {
            return []
        }

        var patients: [CareRecipient] = []

        for (index, id) in ids.enumerated() {
            if let patient = fetchCareRecipient(id: id) {
                patients.append(patient)
            }
        }

        return patients
    }
    
    func removeCurrentPatient() {
        currentPatient = nil
        if let user = fetchUser() {
            user.activeCareRecipient = nil
            save()
        }
    }
    
    func setShift(_ shifts: [PeriodEnum]) {
        guard let user = fetchUser() else { return }
        user.preferenceNotification = shifts.map { $0.rawValue }.joined(separator: ",")
        save()
    }
    
    func getShift() -> [PeriodEnum] {
        guard let user = fetchUser(),
              let stored = user.preferenceNotification else { return [] }
        return stored
            .split(separator: ",")
            .compactMap { PeriodEnum(rawValue: String($0)) }
    }
    
    // MARK: - Helpers
    private func save() {
        try? context.save()
    }
}
