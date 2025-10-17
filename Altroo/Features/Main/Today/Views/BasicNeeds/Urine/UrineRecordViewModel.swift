//
//  UrineRecordViewModel.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 16/10/25.
//

import Foundation
import UIKit
import Combine

final class UrineRecordViewModel {
    let urineService: BasicNeedsFacade
    let userService: UserServiceSession
    let coreDataService: CoreDataService
    
    @Published var selectedUrineColor: UIColor? = nil
    @Published var selectedCharacteristics: [UrineCharacteristicsEnum] = []
    @Published var urineObservation: String = ""
    
    init(urineService: BasicNeedsFacade, coreDataService: CoreDataService, userService: UserServiceSession) {
        self.urineService = urineService
        self.coreDataService = coreDataService
        self.userService = userService
    }
    
    private func getCurrentCareRecipient() -> CareRecipient? {
        userService.fetchCurrentPatient()
    }
    
    func createUrineRecord() {
        guard
            let uiColor = selectedUrineColor,
            let careRecipient = getCurrentCareRecipient()
        else { return }
        
        let colorHex = uiColor.hexString
        
        urineService.addUrine(
            period: PeriodEnum.current,
            date: Date(),
            color: colorHex,
            in: careRecipient,
            urineCharacteristics: selectedCharacteristics,
            observation: urineObservation
        )
    }
    
    func getNameFromCharacteristicsOptions(characteristics: UrineCharacteristicsEnum) -> String {
        switch characteristics {
        case .excessFoam:
            return "Excesso de espuma"
        case .pain:
            return "Dor"
        case .incontinence:
            return "Incontinência"
        case .unusualOdor:
            return "Cheiro Anormal"
        }
    }
}
