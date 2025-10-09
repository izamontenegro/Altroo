//
//  PatientSessionService.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 23/09/25.
//

import Foundation

//final class PatientSessionService: PatientService {
//    private var activePatientId: String?
//    var hasPatient: Bool { activePatientId != nil }
//    var activePatientUUID: UUID? { activePatientId.flatMap(UUID.init(uuidString:)) }
//
//    func save(patientId: UUID) { self.activePatientId = patientId.uuidString }
//    func clear() { activePatientId = nil }
//}

final class PatientSessionService: PatientService {
    private let activePatientKey = "activePatientId"
    
    var activePatientId: String? {
        get { UserDefaults.standard.string(forKey: activePatientKey) }
        set { UserDefaults.standard.setValue(newValue, forKey: activePatientKey) }
    }
    
    var hasPatient: Bool { activePatientId != nil }
    var activePatientUUID: UUID? { activePatientId.flatMap(UUID.init(uuidString:)) }

    func save(patientId: UUID) { activePatientId = patientId.uuidString }
    func clear() { activePatientId = nil }
}
