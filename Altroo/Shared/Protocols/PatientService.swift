//
//  PatientService.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 22/09/25.
//

protocol PatientService {
    var hasPatient: Bool { get }
    func save(patientName: String)
    func clear()
}
