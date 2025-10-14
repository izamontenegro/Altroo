//
//  UserServiceSession.swift
//  Altroo
//
//  Created by Layza Maria Rodrigues Carneiro on 11/10/25.
//

import CoreData
import UIKit

class UserServiceSession: UserServiceProtocol {
    
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
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
        guard let user = fetchUser() else { return }
        user.activeCareRecipient = patient
        save()
    }
    
    func addPatient(_ patient: CareRecipient) {
        guard let user = fetchUser() else { return }
        user.addToCareRecipient(patient)
        save()
    }
    
    func removePatient(_ patient: CareRecipient) {
        guard let user = fetchUser() else { return }
        user.removeFromCareRecipient(patient)
        save()
    }
    
    func fetchPatients() -> [CareRecipient] {
        guard let user = fetchUser() else { return [] }
        return user.careRecipient?.allObjects as? [CareRecipient] ?? []
    }
    
    func fetchCurrentPatient() -> CareRecipient? {
        guard let user = fetchUser(), let patient = user.activeCareRecipient else {
            return nil
        }
        return patient
    }
    
    func removeCurrentPatient() {
        guard let user = fetchUser(), user.activeCareRecipient != nil else { return }
        user.activeCareRecipient = nil
        save()
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
