//
//  PatientFacade.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 29/09/25.
//

import Foundation

class CareRecipientFacade {
    let persistenceService: CoreDataService
    let basicNeedsFacade: BasicNeedsFacade
    
    init(basicNeedsFacade: BasicNeedsFacade, persistenceService: CoreDataService) {
        self.basicNeedsFacade = basicNeedsFacade
        self.persistenceService = persistenceService
    }
}
