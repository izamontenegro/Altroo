//
//  PatientSessionService.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 22/09/25.
//

final class PatientSessionService: PatientService {
    private var patientName: String?
    var hasPatient: Bool { patientName != nil }
    func save(patientName: String) { self.patientName = patientName }
    func clear() { patientName = nil }
}
