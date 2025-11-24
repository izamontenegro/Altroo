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
    @Published var customUnit: HydrationUnit = .milliliter

    @Published var targetValue: Double = 0
    @Published var targetUnit: HydrationUnit = .milliliter

    init(
        careRecipientFacade: CareRecipientFacade,
        userService: UserServiceSession,
        coreDataService: CoreDataService,
        historyService: HistoryService
    ) {
        self.careRecipientFacade = careRecipientFacade
        self.userService = userService
        self.coreDataService = coreDataService
        self.historyService = historyService
    }
    
    private func convertToMl(_ value: Double, unit: HydrationUnit) -> Double {
        switch unit {
        case .milliliter:
            return value
        case .liter:
            return value * 1000.0
        }
    }
    
    func saveHydrationMeasure() {
        guard
            let careRecipient = userService.fetchCurrentPatient(),
            let amount = selectedAmount
        else { return }
        
        let totalWaterMl: Double
        
        if amount == .custom {
            totalWaterMl = convertToMl(customValue, unit: customUnit)
        } else {
            totalWaterMl = amount.milliliters
        }
        
        careRecipientFacade.setWaterMeasure(totalWaterMl, careRecipient)
    }
    
    func saveHydrationTarget() {
        guard
            let careRecipient = userService.fetchCurrentPatient()
        else { return }
       
        let targetMl = convertToMl(targetValue, unit: targetUnit)
        careRecipientFacade.setWaterTarget(targetMl, careRecipient)
    }
    
    func loadTargetValue() {
        guard
            let careRecipient = userService.fetchCurrentPatient()
        else { return }
        
        targetValue = careRecipient.waterTarget
        targetUnit = .milliliter
    }
}
