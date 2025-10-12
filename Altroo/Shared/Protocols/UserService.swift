//
//  UserService.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 22/09/25.
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
