//
//  CareRecipientFacade+PersonalCare.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 30/09/25.
//

protocol PersonalCareProtocol {
    func addHygieneState(hygieneState: HygieneEnum, personalCare: PersonalCare)
    func addFeedingState(feedingState: FeedingEnum, personalCare: PersonalCare)
    func addExcretionState(excretionState: ExcretionEnum, personalCare: PersonalCare)
    func addEquipmentState(equipmentState: EquipmentEnum, personalCare: PersonalCare)
    func addBathState(bathState: BathEnum, personalCare: PersonalCare)
}

extension CareRecipientFacade: PersonalCareProtocol {
    func addHygieneState(hygieneState: HygieneEnum, personalCare: PersonalCare) {
        personalCare.hygieneState = hygieneState.rawValue
        
        persistenceService.saveContext()
    }
    
    func addFeedingState(feedingState: FeedingEnum, personalCare: PersonalCare) {
        personalCare.feedingState = feedingState.rawValue
        
        persistenceService.saveContext()
    }
    
    func addExcretionState(excretionState: ExcretionEnum, personalCare: PersonalCare) {
        personalCare.excretionState = excretionState.rawValue
        
        persistenceService.saveContext()
    }
    
    func addEquipmentState(equipmentState: EquipmentEnum, personalCare: PersonalCare) {
        personalCare.equipmentState = equipmentState.rawValue
        
        persistenceService.saveContext()
    }
    
    func addBathState(bathState: BathEnum, personalCare: PersonalCare) {
        personalCare.bathState = bathState.rawValue
        
        persistenceService.saveContext()
    }
}
