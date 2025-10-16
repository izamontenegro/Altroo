//
//  UrineRecordViewModel.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 16/10/25.
//

import Foundation

class UrineRecordViewModel {
    let urineService: BasicNeedsFacadeProtocol
    let coreDataService: CoreDataService
    
    init(urineService: BasicNeedsFacade, coreDataService: CoreDataService) {
        self.urineService = urineService
        self.coreDataService = coreDataService
    }
}
