//
//  EditMedicalRecordViewModel+PhysicalState.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 31/10/25.
//

import Combine
import CloudKit
import CoreData

struct PhysicalStateFormState: Equatable {
    var visionState: VisionEnum? = nil
    var hearingState: HearingEnum? = nil
    var oralHealthState: OralHealthEnum? = nil
    var mobilityState: MobilityEnum? = nil
}


extension EditMedicalRecordViewModel {
    
    func loadInitialPhysicalStateFormState() {
        guard let patient = currentPatient(),
              let physicalState = patient.physicalState else {
            physicalStateFormState = PhysicalStateFormState()
            return
        }

        physicalStateFormState = PhysicalStateFormState(
            visionState: physicalState.visionState.flatMap { VisionEnum(rawValue: $0) },
            hearingState: physicalState.hearingState.flatMap { HearingEnum(rawValue: $0) },
            oralHealthState: physicalState.oralHealthState.flatMap { OralHealthEnum(rawValue: $0) },
            mobilityState: physicalState.mobilityState.flatMap { MobilityEnum(rawValue: $0) }
        )
    }

    func updateVisionState(_ value: VisionEnum?) {
        var draft = physicalStateFormState
        draft.visionState = value
        physicalStateFormState = draft
    }

    func updateHearingState(_ value: HearingEnum?) {
        var draft = physicalStateFormState
        draft.hearingState = value
        physicalStateFormState = draft
    }

    func updateOralHealthState(_ value: OralHealthEnum?) {
        var draft = physicalStateFormState
        draft.oralHealthState = value
        physicalStateFormState = draft
    }

    func updateMobilityState(_ value: MobilityEnum?) {
        var draft = physicalStateFormState
        draft.mobilityState = value
        physicalStateFormState = draft
    }

    func persistPhysicalStateFormState() {
        guard let patient = currentPatient(),
              let physicalState = patient.physicalState else { return }

        if let value = physicalStateFormState.visionState {
            careRecipientFacade.addVisionState(visionState: value, physicalState: physicalState)
        }
        if let value = physicalStateFormState.hearingState {
            careRecipientFacade.addHearingState(hearingState: value, physicalState: physicalState)
        }
        if let value = physicalStateFormState.oralHealthState {
            careRecipientFacade.addOralHealthState(oralHealthState: value, physicalState: physicalState)
        }
        if let value = physicalStateFormState.mobilityState {
            careRecipientFacade.addMobilityState(mobilityState: value, physicalState: physicalState)
        }
    }
}
