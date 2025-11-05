//
//  UrineRecordViewModel.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 16/10/25.
//

import Foundation
import UIKit
import Combine
import CoreData

final class UrineRecordViewModel {
    let urineService: BasicNeedsFacade
    let userService: UserServiceSession
    let coreDataService: CoreDataService
    private let historyService: HistoryService

    
    @Published var selectedUrineColor: UrineColorsEnum? = nil
    @Published var selectedCharacteristics: [UrineCharacteristicsEnum] = []
    @Published var urineObservation: String = ""
    
    init(urineService: BasicNeedsFacade, coreDataService: CoreDataService, userService: UserServiceSession, historyService: HistoryService) {
        self.urineService = urineService
        self.coreDataService = coreDataService
        self.userService = userService
        self.historyService = historyService
    }
    
    func createUrineRecord() {
        guard
            let careRecipient = getCurrentCareRecipient()
        else { return }
        
        let author = coreDataService.currentPerformerName(for: careRecipient)
        
        urineService.addUrine(
            period: PeriodEnum.current,
            date: Date(),
            color: selectedUrineColor ?? .light,
            in: careRecipient,
            urineCharacteristics: selectedCharacteristics, author: author,
            observation: urineObservation
        )
        
        historyService.addHistoryItem(title: "Registrou urina", author: author, date: Date(), type: .urine, to: careRecipient)
        
    }
    
    
    private func getCurrentCareRecipient() -> CareRecipient? {
        userService.fetchCurrentPatient()
    }
}
