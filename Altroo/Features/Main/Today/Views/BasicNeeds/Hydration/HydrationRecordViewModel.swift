//
//  HydrationRecordViewModel.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 19/10/25.
//
import Foundation
import Combine
import CoreData

final class HydrationRecordViewModel {
    private let careRecipientFacade: CareRecipientFacade
    private let userService: UserServiceSession
    private let coreDataService: CoreDataService
    private let historyService: HistoryService

    @Published var selectedAmount: HydrationAmountEnum? = nil
    @Published var customValue: Double = 0
    @Published var targetValue: Double = 0


    init(careRecipientFacade: CareRecipientFacade, userService: UserServiceSession, coreDataService: CoreDataService, historyService: HistoryService) {
        self.careRecipientFacade = careRecipientFacade
        self.userService = userService
        self.coreDataService = coreDataService
        self.historyService = historyService
    }
    
    func saveHydrationMeasure() {
        guard
            let careRecipient = userService.fetchCurrentPatient(),
            let amount = selectedAmount
        else { return }
        
        let totalWater = amount == .custom ? customValue : amount.milliliters
        
        careRecipientFacade.setWaterMeasure(totalWater, careRecipient)
    }
    
    func saveHydrationTarget() {
        guard
            let careRecipient = userService.fetchCurrentPatient()
        else { return }
       
        careRecipientFacade.setWaterTarget(targetValue, careRecipient)
    }
    
    func loadTargetValue() {
        guard
            let careRecipient = userService.fetchCurrentPatient()
        else { return }
        
        targetValue = careRecipient.waterTarget
    }
}
