//
//  PatientFacade.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 29/09/25.
//

import Foundation

class PatientFacade {
    private let basicNeedsFacade: BasicNeedsFacade
    
    init(basicNeedsFacade: BasicNeedsFacade) {
        self.basicNeedsFacade = basicNeedsFacade
    }
}
