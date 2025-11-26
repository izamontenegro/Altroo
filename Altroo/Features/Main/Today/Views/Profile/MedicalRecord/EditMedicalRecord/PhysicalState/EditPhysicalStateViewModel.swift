//
//  EditMedicalRecordViewModel+PhysicalState.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 31/10/25.
//
import Foundation

struct PhysicalStateFormState: Equatable {
    var visionState: VisionEnum? = nil
    var hearingState: HearingEnum? = nil
    var oralHealthStates: [OralHealthEnum] = []
    var mobilityState: MobilityEnum? = nil
}

final class EditPhysicalStateViewModel {

    private let userService: UserServiceProtocol
    private let careRecipientFacade: CareRecipientFacade

    var physicalStateFormState = PhysicalStateFormState()

    init(userService: UserServiceProtocol, careRecipientFacade: CareRecipientFacade) {
        self.userService = userService
        self.careRecipientFacade = careRecipientFacade
    }

    func currentPatient() -> CareRecipient? {
        userService.fetchCurrentPatient()
    }

    // MARK: - Load inicial

    func loadInitialPhysicalState() {
        guard let patient = currentPatient(),
              let physicalState = patient.physicalState else {
            physicalStateFormState = PhysicalStateFormState()
            return
        }

        physicalStateFormState = PhysicalStateFormState(
            visionState: physicalState.visionState.flatMap { VisionEnum(rawValue: $0) },
            hearingState: physicalState.hearingState.flatMap { HearingEnum(rawValue: $0) },
            oralHealthStates: physicalState.oralHealthState?
                .compactMap { OralHealthEnum(rawValue: $0) } ?? [],
            mobilityState: physicalState.mobilityState.flatMap { MobilityEnum(rawValue: $0) }
        )
    }

    // MARK: - Updates

    func updateVisionState(_ value: VisionEnum?) {
        physicalStateFormState.visionState = value
    }

    func updateHearingState(_ value: HearingEnum?) {
        physicalStateFormState.hearingState = value
    }
    
    func updateOralHealthStates(_ values: [OralHealthEnum]) {
        physicalStateFormState.oralHealthStates = values
    }

    func updateMobilityState(_ value: MobilityEnum?) {
        physicalStateFormState.mobilityState = value
    }

    // MARK: - Persistência

    func persistPhysicalState() {
        guard let patient = currentPatient(),
              let physicalState = patient.physicalState else { return }

        if let value = physicalStateFormState.visionState {
            careRecipientFacade.addVisionState(visionState: value, physicalState: physicalState)
        }
        if let value = physicalStateFormState.hearingState {
            careRecipientFacade.addHearingState(hearingState: value, physicalState: physicalState)
        }
        
        let oralHealthStates = physicalStateFormState.oralHealthStates
        
        
        careRecipientFacade.addOralHealthState(
                oralHealthState: oralHealthStates,
                physicalState: physicalState
        )

        if let value = physicalStateFormState.mobilityState {
            careRecipientFacade.addMobilityState(mobilityState: value, physicalState: physicalState)
        }

        careRecipientFacade.updateMedicalRecord(careRecipient: patient)
        
        NotificationCenter.default.post(name: .medicalRecordDidChange, object: nil)
    }
}
