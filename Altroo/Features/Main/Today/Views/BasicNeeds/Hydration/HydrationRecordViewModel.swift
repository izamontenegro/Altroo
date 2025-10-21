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
    private let basicNeedsFacade: BasicNeedsFacade
    private let userService: UserServiceSession

    @Published var selectedAmount: HydrationAmountEnum? = nil
    @Published var customValue: Double = 0

    init(basicNeedsFacade: BasicNeedsFacade, userService: UserServiceSession) {
        self.basicNeedsFacade = basicNeedsFacade
        self.userService = userService
    }

    func saveHydrationRecord() {
        guard
            let careRecipient = userService.fetchCurrentPatient(),
            let amount = selectedAmount
        else { return }

        let totalWater = amount == .custom ? customValue : amount.milliliters
        
        basicNeedsFacade.addHydration(
            period: PeriodEnum.current,
            date: Date(),
            waterQuantity: totalWater,
            in: careRecipient
        )
        
        checkSavedRecord()
    }

    private func checkSavedRecord() {
        guard let careRecipient = userService.fetchCurrentPatient() else { return }

        if let context = careRecipient.managedObjectContext {
            let request: NSFetchRequest<HydrationRecord> = HydrationRecord.fetchRequest()
            do {
                let results = try context.fetch(request)
//                print("💧 [DEBUG] Total hydration records encontrados: \(results.count)")
//                if let last = results.last {
//                    print("💧 [DEBUG] Last Record:")
//                    print("• ID:", last.id)
//                    print("• Date:", last.date ?? Date())
//                    print("• Period:", last.period ?? "—")
//                    print("• Quantity:", last.waterQuantity)
//                }
            } catch {
                print("⚠️ [DEBUG] Error fetching HydrationRecord:", error.localizedDescription)
            }
        } else {
            print("⚠️ [DEBUG] None managedObjectContext.")
        }
    }
}
