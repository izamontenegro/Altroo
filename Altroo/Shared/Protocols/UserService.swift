//
//  UserService.swift
//  Altroo
//
//  Created by Layza Maria Rodrigues Carneiro on 12/10/25.
//

import Foundation

protocol UserServiceProtocol {
    func fetchUser() -> User?
    func createUser(name: String, category: String) -> User
    func setName(_ name: String)
    func setCategory(_ category: String)
    func setCurrentPatient(_ patient: CareRecipient)
    func addPatient(_ patient: CareRecipient)
    func removePatient(_ patient: CareRecipient)
    func fetchPatients() -> [CareRecipient]
    func fetchCurrentPatient() -> CareRecipient?
    func removeCurrentPatient()
}
