//
//  PatientService.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 22/09/25.
//

import Foundation

protocol PatientService {
    var hasPatient: Bool { get }
    func save(patientId: UUID)
    func clear()
}
