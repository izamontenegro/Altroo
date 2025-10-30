//
//  EditMedicalRecordViewModel.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 29/10/25.
//

import UIKit
import Combine
import CloudKit
import CoreData

// TODO: maybe a reload function

final class EditMedicalRecordViewModel {
    var userService: UserServiceProtocol

    init(userService: UserServiceProtocol) {
        self.userService = userService
    }
    
    private func currentPatient() -> CareRecipient? {
        userService.fetchCurrentPatient()
    }

    
    // MARK: - Text builders
    
    // MARK: Personal data
    func getName() -> String {
        currentPatient()?.personalData?.name ?? ""
    }

    func getAddress() -> String {
        currentPatient()?.personalData?.address ?? ""
    }

    func getDateOfBirth() -> String {
        DateFormatterHelper.birthDateFormatter(from: currentPatient()?.personalData?.dateOfBirth)
    }

    func getWeight() -> String {
        currentPatient()?.personalData?.weight.description ?? ""
    }

    func getHeight() -> String {
        currentPatient()?.personalData?.height.description ?? ""
    }

    func getContacts() -> String {
        MedicalRecordFormatter.contactsList(from: currentPatient()?.personalData?.contacts as? Set<Contact>)
    }
    
    func calculateAge(from date: Date) -> String {
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: date, to: Date())
        let years = ageComponents.year ?? 0
        return "\(years) anos"
    }
    
    // MARK: Health Problems

    
    // MARK: Physical State

    
    // MARK: Mental Health

    
    // MARK: Personal care

}

