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

    @Published var selectedAmount: HydrationAmountEnum? = nil
    @Published var customValue: Double = 0

    init(careRecipientFacade: CareRecipientFacade, userService: UserServiceSession) {
        self.careRecipientFacade = careRecipientFacade
        self.userService = userService
    }
    
    // func to save hydration measure
    func saveHydrationMeasure() {
        guard
            let careRecipient = userService.fetchCurrentPatient(),
            let amount = selectedAmount
        else { return }

        let totalWater = amount == .custom ? customValue : amount.milliliters
        
        careRecipientFacade.setWaterMeasure(totalWater, careRecipient)
    }

    private func checkSavedRecord() {
        guard let careRecipient = userService.fetchCurrentPatient() else { return }

        if let context = careRecipient.managedObjectContext {
            let request: NSFetchRequest<HydrationRecord> = HydrationRecord.fetchRequest()
            do {
                let results = try context.fetch(request)
                print("💧 [DEBUG] Total hydration records encontrados: \(results.count)")
                if let last = results.last {
                    print("💧 [DEBUG] Last Record:")
                    print("• ID:", last.id)
                    print("• Date:", last.date ?? Date())
                    print("• Period:", last.period ?? "—")
                    print("• Quantity:", last.waterQuantity)
                }
            } catch {
                print("⚠️ [DEBUG] Error fetching HydrationRecord:", error.localizedDescription)
            }
        } else {
            print("⚠️ [DEBUG] None managedObjectContext.")
        }
    }
}
