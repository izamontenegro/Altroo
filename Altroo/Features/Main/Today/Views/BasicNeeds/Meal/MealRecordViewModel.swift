//
//  MealRecordViewModel.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 19/10/25.
//
import UIKit
import Combine
import CoreData

final class MealRecordViewModel {
    let feedingService: BasicNeedsFacade
    let userService: UserServiceSession
    let coreDataService: CoreDataService

    @Published var selectedMealCategory: MealCategoryEnum? = nil
    @Published var selectedMealAmountEaten: MealAmountEatenEnum? = nil
    @Published var notes: String = ""
    @Published var photoData: Data? = nil

    init(feedingService: BasicNeedsFacade,
         coreDataService: CoreDataService,
         userService: UserServiceSession) {
        self.feedingService = feedingService
        self.coreDataService = coreDataService
        self.userService = userService
    }

    func createFeedingRecord() {
        guard
            let careRecipient = getCurrentCareRecipient(),
            let selectedMealCategory,
            let selectedMealAmountEaten
        else { return }
        
        feedingService.addFeeding(
            amountEaten: selectedMealAmountEaten,
            date: Date(),
            // FIXME: UPDATE HERE WHEN MERGED
            period: PeriodEnum.afternoon,
            notes: notes,
            mealCategory: selectedMealCategory,
            in: careRecipient
        )
        
        checkSavedRecord()
    }
    
    // MARK: - 🔍 Debug: verify that the record was actually saved in Core Data
    // This block fetches all meals records from the context and prints the last one.
    // It’s only for debugging until we have a proper UI (history) to display the data.
    
    private func checkSavedRecord() {
            guard let careRecipient = getCurrentCareRecipient() else { return }

            if let context = careRecipient.managedObjectContext {
                let request: NSFetchRequest<FeedingRecord> = FeedingRecord.fetchRequest()
                do {
                    let results = try context.fetch(request)
                    print("🍽️ [DEBUG] Total feeding records found: \(results.count)")
                    if let last = results.last {
                        print("🍽️ [DEBUG] Last saved feeding record:")
                        print("• ID:", last.id)
                        print("• Date:", last.date ?? Date())
                        print("• Period:", last.period ?? "—")
                        print("• Category:", last.mealCategory ?? "—")
                        print("• Amount Eaten:", last.amountEaten ?? "—")
                        print("• Notes:", last.notes ?? "—")
                    }
                } catch {
                    print("⚠️ [DEBUG] Failed to fetch FeedingRecord:", error.localizedDescription)
                }
            } else {
                print("⚠️ [DEBUG] No managedObjectContext found for the current CareRecipient.")
            }
        }
    
    private func getCurrentCareRecipient() -> CareRecipient? {
        userService.fetchCurrentPatient()
    }
}
