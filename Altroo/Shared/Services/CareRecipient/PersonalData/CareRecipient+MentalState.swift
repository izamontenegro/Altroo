//
//  CareRecipient+MentalState.swift
//  Altroo
//
//  Created by Layza Maria Rodrigues Carneiro on 02/10/25.
//

protocol MentalStateProtocol {
    func addEmotionalState(emotionalState: EmotionalStateEnum, mentalState: MentalState)
    func addMemoryState(memoryState: MemoryEnum, mentalState: MentalState)
    func addOrientationState(orientationState: [OrientationEnum], mentalState: MentalState)
    func addCognitionState(cognitionState: CognitionEnum, mentalState: MentalState)
}

extension CareRecipientFacade: MentalStateProtocol {
    
    func addEmotionalState(emotionalState: EmotionalStateEnum, mentalState: MentalState) {
        mentalState.emotionalState = emotionalState.rawValue
        
        persistenceService.save()
    }
    
    func addMemoryState(memoryState: MemoryEnum, mentalState: MentalState) {
        mentalState.memoryState = memoryState.rawValue
        
        persistenceService.save()
    }
    
    func addOrientationState(orientationState: [OrientationEnum], mentalState: MentalState) {
        if orientationState.isEmpty {
            mentalState.orientationState = []
        } else {
            mentalState.orientationState = orientationState.map { $0.rawValue }
        }
        
        persistenceService.save()
    }
    
    func addCognitionState(cognitionState: CognitionEnum, mentalState: MentalState) {
        mentalState.cognitionState = cognitionState.rawValue
        
        persistenceService.save()
    }

}
