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
    private let coreDataService: CoreDataService
    private let historyService: HistoryService

    @Published var selectedAmount: HydrationAmountEnum? = nil
    @Published var customValue: Double = 0

    init(basicNeedsFacade: BasicNeedsFacade, userService: UserServiceSession, coreDataService: CoreDataService, historyService: HistoryService) {
        self.basicNeedsFacade = basicNeedsFacade
        self.userService = userService
        self.coreDataService = coreDataService
        self.historyService = historyService
    }

    func saveHydrationRecord() {
        guard
            let careRecipient = userService.fetchCurrentPatient(),
            let amount = selectedAmount
        else { return }

        let totalWater = amount == .custom ? customValue : amount.milliliters
        
        let author = coreDataService.currentPerformerName(for: careRecipient)
        
        basicNeedsFacade.addHydration(
            period: PeriodEnum.current,
            date: Date(),
            waterQuantity: totalWater,
            author: author,
            in: careRecipient
        )
        
        historyService.addHistoryItem(title: "Bebeu \(totalWater)ml de água", author: author, date: Date(), to: careRecipient)
        
        checkSavedRecord()
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
                    print("- author:", last.author)
                }
            } catch {
                print("⚠️ [DEBUG] Error fetching HydrationRecord:", error.localizedDescription)
            }
        } else {
            print("⚠️ [DEBUG] None managedObjectContext.")
        }
    }
}
