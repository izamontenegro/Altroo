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
