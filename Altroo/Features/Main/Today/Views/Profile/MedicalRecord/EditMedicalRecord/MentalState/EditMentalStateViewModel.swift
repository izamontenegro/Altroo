//
//  EditMedicalRecordViewModel+MentalState.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 31/10/25.
//
import Foundation

struct MentalStateFormState: Equatable {
    var emotionalState: [EmotionalStateEnum] = []
    var memoryState: MemoryEnum? = nil
    var orientationState: [OrientationEnum] = []
    var cognitionState: CognitionEnum? = nil
}

final class EditMentalStateViewModel {

    private let userService: UserServiceProtocol
    private let careRecipientFacade: CareRecipientFacade

    var mentalStateFormState = MentalStateFormState()

    init(userService: UserServiceProtocol, careRecipientFacade: CareRecipientFacade) {
        self.userService = userService
        self.careRecipientFacade = careRecipientFacade
    }

    func currentPatient() -> CareRecipient? {
        userService.fetchCurrentPatient()
    }

    func loadInitialMentalState() {
        guard let patient = currentPatient(),
              let mentalState = patient.mentalState else {
            mentalStateFormState = MentalStateFormState()
            return
        }

        mentalStateFormState = MentalStateFormState(
            emotionalState: mentalState.emotionalState?
                .compactMap { EmotionalStateEnum(rawValue: $0) } ?? [],
            memoryState: mentalState.memoryState.flatMap { MemoryEnum(rawValue: $0) },
            orientationState: mentalState.orientationState?
                .compactMap { OrientationEnum(rawValue: $0) } ?? [],
            cognitionState: mentalState.cognitionState.flatMap { CognitionEnum(rawValue: $0) }
        )
        
    }
    
    func updateEmotionalState(_ values: [EmotionalStateEnum]) {
        mentalStateFormState.emotionalState = values
    }

    func updateMemoryState(_ value: MemoryEnum?) {
        mentalStateFormState.memoryState = value
    }

    func updateOrientationState(_ value: [OrientationEnum]) {
        mentalStateFormState.orientationState = value
    }

    func updateCognitionState(_ value: CognitionEnum?) {
        mentalStateFormState.cognitionState = value
    }

    func persistMentalState() {
        guard let patient = currentPatient(),
              let mentalState = patient.mentalState else { return }

        let emotionalStates = mentalStateFormState.emotionalState
        careRecipientFacade.addEmotionalState(
            emotionalState: emotionalStates,
            mentalState: mentalState
        )
        if let value = mentalStateFormState.memoryState {
            careRecipientFacade.addMemoryState(memoryState: value, mentalState: mentalState)
        }
        
        let orientationStates = mentalStateFormState.orientationState
        
        
        careRecipientFacade.addOrientationState(orientationState: orientationStates, mentalState: mentalState)
        
        if let value = mentalStateFormState.cognitionState {
            careRecipientFacade.addCognitionState(cognitionState: value, mentalState: mentalState)
        }
        
        careRecipientFacade.updateMedicalRecord(careRecipient: patient)

    }
}
