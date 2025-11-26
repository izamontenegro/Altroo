//
//  CareRecipient+PhysicalState.swift
//  Altroo
//
//  Created by Layza Maria Rodrigues Carneiro on 02/10/25.
//

protocol PhysicalStateProtocol {
    func addVisionState(visionState: VisionEnum, physicalState: PhysicalState)
    func addHearingState(hearingState: HearingEnum, physicalState: PhysicalState)
    func addOralHealthState(oralHealthState: [OralHealthEnum], physicalState: PhysicalState)
    func addMobilityState(mobilityState: MobilityEnum, physicalState: PhysicalState)
}

extension CareRecipientFacade: PhysicalStateProtocol {
    
    func addVisionState(visionState: VisionEnum, physicalState: PhysicalState) {
        physicalState.visionState = visionState.rawValue
        
        persistenceService.save()
    }
    
    func addHearingState(hearingState: HearingEnum, physicalState: PhysicalState) {
        physicalState.hearingState = hearingState.rawValue
        
        persistenceService.save()
    }
    
    func addOralHealthState(oralHealthState: [OralHealthEnum], physicalState: PhysicalState) {
        if oralHealthState.isEmpty {
            physicalState.oralHealthState = []
        } else {
            physicalState.oralHealthState = oralHealthState.map { $0.rawValue }
        }
        

        persistenceService.save()
    }
    
    func addMobilityState(mobilityState: MobilityEnum, physicalState: PhysicalState) {
        physicalState.mobilityState = mobilityState.rawValue
        
        persistenceService.save()
    }
    
}
