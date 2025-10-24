//
//  StoolRecordViewModel.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 18/10/25.
//

import Foundation
import UIKit
import Combine
import CoreData

final class StoolRecordViewModel {
    let stoolService: BasicNeedsFacade
    let userService: UserServiceSession
    let coreDataService: CoreDataService
    private let historyService: HistoryService

    
    @Published var selectedStoolType: StoolTypesEnum? = nil
    @Published var selectedStoolColor: UIColor? = nil
    @Published var selectedCharacteristics: [UrineCharacteristicsEnum] = []
    @Published var notes: String = ""
    
    init(stoolService: BasicNeedsFacade, coreDataService: CoreDataService, userService: UserServiceSession, historyService: HistoryService) {
        self.stoolService = stoolService
        self.coreDataService = coreDataService
        self.userService = userService
        self.historyService = historyService
    }
    
    func createStoolRecord() {
        
        guard
            let careRecipient = getCurrentCareRecipient()
        else { return }
        
        let author = coreDataService.currentPerformerName(for: careRecipient)
        
        stoolService.addStool(period: PeriodEnum.current, date: Date(), format: selectedStoolType?.rawValue ?? "", notes: notes, color: selectedStoolColor?.hexString ?? "", author: author, in: careRecipient)
        
        historyService.addHistoryItem(title: "Registrou fezes \(selectedStoolType?.displayText ?? "")", author: author, date: Date(), type: .stool, to: careRecipient)
    }
    
    private func getCurrentCareRecipient() -> CareRecipient? {
        userService.fetchCurrentPatient()
    }
}
