//
//  EditMedicalRecordViewModel+PersonalCare.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 31/10/25.
//

import Combine
import CloudKit
import CoreData

struct PersonalCareFormState: Equatable {
    var hygieneState: HygieneEnum? = nil
    var feedingState: FeedingEnum? = nil
    var excretionState: ExcretionEnum? = nil
    var equipmentState: EquipmentEnum? = nil
    var bathState: BathEnum? = nil
}

extension EditMedicalRecordViewModel {

    func loadInitialPersonalCareFormState() {
        guard let patient = currentPatient(),
              let personalCare = patient.personalCare else {
            personalCareFormState = PersonalCareFormState()
            return
        }

        personalCareFormState = PersonalCareFormState(
            hygieneState: personalCare.hygieneState.flatMap { HygieneEnum(rawValue: $0) },
            feedingState: personalCare.feedingState.flatMap { FeedingEnum(rawValue: $0) },
            excretionState: personalCare.excretionState.flatMap { ExcretionEnum(rawValue: $0) },
            equipmentState: personalCare.equipmentState.flatMap { EquipmentEnum(rawValue: $0) },
            bathState: personalCare.bathState.flatMap { BathEnum(rawValue: $0) }
        )
    }

    func updateHygieneState(_ value: HygieneEnum?) {
        var draft = personalCareFormState
        draft.hygieneState = value
        personalCareFormState = draft
    }

    func updateFeedingState(_ value: FeedingEnum?) {
        var draft = personalCareFormState
        draft.feedingState = value
        personalCareFormState = draft
    }

    func updateExcretionState(_ value: ExcretionEnum?) {
        var draft = personalCareFormState
        draft.excretionState = value
        personalCareFormState = draft
    }

    func updateEquipmentState(_ value: EquipmentEnum?) {
        var draft = personalCareFormState
        draft.equipmentState = value
        personalCareFormState = draft
    }

    func updateBathState(_ value: BathEnum?) {
        var draft = personalCareFormState
        draft.bathState = value
        personalCareFormState = draft
    }

    func persistPersonalCareFormState() {
        guard let patient = currentPatient(),
              let personalCare = patient.personalCare else { return }

        if let value = personalCareFormState.hygieneState {
            careRecipientFacade.addHygieneState(hygieneState: value, personalCare: personalCare)
        }
        if let value = personalCareFormState.feedingState {
            careRecipientFacade.addFeedingState(feedingState: value, personalCare: personalCare)
        }
        if let value = personalCareFormState.excretionState {
            careRecipientFacade.addExcretionState(excretionState: value, personalCare: personalCare)
        }
        if let value = personalCareFormState.equipmentState {
            careRecipientFacade.addEquipmentState(equipmentState: value, personalCare: personalCare)
        }
        if let value = personalCareFormState.bathState {
            careRecipientFacade.addBathState(bathState: value, personalCare: personalCare)
        }
    }
}
