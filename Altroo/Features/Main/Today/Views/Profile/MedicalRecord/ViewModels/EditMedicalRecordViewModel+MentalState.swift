//
//  EditMedicalRecordViewModel+MentalState.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 31/10/25.
//

import Combine
import CloudKit
import CoreData

struct MentalStateFormState: Equatable {
    var emotionalState: EmotionalStateEnum? = nil
    var memoryState: MemoryEnum? = nil
    var orientationState: OrientationEnum? = nil
    var cognitionState: CognitionEnum? = nil
}

extension EditMedicalRecordViewModel {
    
    func loadInitialMentalStateFormState() {
        guard let patient = currentPatient(),
              let mentalState = patient.mentalState else {
            mentalStateFormState = MentalStateFormState()
            return
        }

        mentalStateFormState = MentalStateFormState(
            emotionalState: mentalState.emotionalState.flatMap { EmotionalStateEnum(rawValue: $0) },
            memoryState: mentalState.memoryState.flatMap { MemoryEnum(rawValue: $0) },
            orientationState: mentalState.orientationState.flatMap { OrientationEnum(rawValue: $0) },
            cognitionState: mentalState.cognitionState.flatMap { CognitionEnum(rawValue: $0) }
        )
    }

    func updateEmotionalState(_ value: EmotionalStateEnum?) {
        var draft = mentalStateFormState
        draft.emotionalState = value
        mentalStateFormState = draft
    }

    func updateMemoryState(_ value: MemoryEnum?) {
        var draft = mentalStateFormState
        draft.memoryState = value
        mentalStateFormState = draft
    }

    func updateOrientationState(_ value: OrientationEnum?) {
        var draft = mentalStateFormState
        draft.orientationState = value
        mentalStateFormState = draft
    }

    func updateCognitionState(_ value: CognitionEnum?) {
        var draft = mentalStateFormState
        draft.cognitionState = value
        mentalStateFormState = draft
    }

    func persistMentalStateFormState() {
        guard let patient = currentPatient(),
              let mentalState = patient.mentalState else { return }

        if let value = mentalStateFormState.emotionalState {
            careRecipientFacade.addEmotionalState(emotionalState: value, mentalState: mentalState)
        }
        if let value = mentalStateFormState.memoryState {
            careRecipientFacade.addMemoryState(memoryState: value, mentalState: mentalState)
        }
        if let value = mentalStateFormState.orientationState {
            careRecipientFacade.addOrientationState(orientationState: value, mentalState: mentalState)
        }
        if let value = mentalStateFormState.cognitionState {
            careRecipientFacade.addCognitionState(cognitionState: value, mentalState: mentalState)
        }
    }
}
