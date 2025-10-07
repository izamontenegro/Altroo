//
//  CareRecipientFacade.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 29/09/25.
//

import Foundation

protocol BasicNeedsFacadeProtocol {}
protocol RoutineActivitiesFacadeProtocol {}

class CareRecipientFacade {
    let persistenceService: CoreDataService
    let basicNeedsFacade: BasicNeedsFacadeProtocol
    let routineActivitiesFacade: RoutineActivitiesFacadeProtocol
        
    init(basicNeedsFacade: BasicNeedsFacadeProtocol,
         routineActivitiesFacade: RoutineActivitiesFacadeProtocol,
         persistenceService: CoreDataService) {
        self.basicNeedsFacade = basicNeedsFacade
        self.routineActivitiesFacade = routineActivitiesFacade
        self.persistenceService = persistenceService
    }
}

extension CareRecipientFacade {
    
    func buildCareRecipient(
        configure: (PersonalData, PersonalCare, MentalState, PhysicalState) -> Void
    ) -> CareRecipient {
        let context = persistenceService.stack.context
        
        let careRecipient = CareRecipient(context: context)
        let personalData = PersonalData(context: context)
        let personalCare = PersonalCare(context: context)
        let mentalState = MentalState(context: context)
        let physicalState = PhysicalState(context: context)
        
        careRecipient.personalData = personalData
        careRecipient.personalCare = personalCare
        careRecipient.mentalState = mentalState
        careRecipient.physicalState = physicalState
        careRecipient.id = UUID()
        
        configure(personalData, personalCare, mentalState, physicalState)
        
        persistenceService.save()

        return careRecipient
    }
    
    func fetchCareRecipient(by id: UUID) -> CareRecipient? {
        return persistenceService.fetchAllCareRecipients().first(where: { $0.id == id })
    }
    
    func deleteCareRecipient(_ careRecipient: CareRecipient) {
        persistenceService.deleteCareRecipient(careRecipient)
    }

}
