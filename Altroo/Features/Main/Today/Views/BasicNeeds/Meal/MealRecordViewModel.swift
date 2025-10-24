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
    private let historyService: HistoryService


    @Published var selectedMealCategory: MealCategoryEnum? = nil
    @Published var selectedMealAmountEaten: MealAmountEatenEnum? = nil
    @Published var notes: String = ""
    @Published var photoData: Data? = nil

    init(feedingService: BasicNeedsFacade,
         coreDataService: CoreDataService,
         userService: UserServiceSession, historyService: HistoryService) {
        self.feedingService = feedingService
        self.coreDataService = coreDataService
        self.userService = userService
        self.historyService = historyService
    }

    func createFeedingRecord() {
        guard
            let careRecipient = getCurrentCareRecipient(),
            let selectedMealCategory,
            let selectedMealAmountEaten
        else { return }
        
        let author = coreDataService.currentPerformerName(for: careRecipient)
        
        feedingService.addFeeding(
            amountEaten: selectedMealAmountEaten,
            date: Date(),
            period: PeriodEnum.current,
            notes: notes,
            mealCategory: selectedMealCategory, author: author,
            in: careRecipient
        )
        
        historyService.addHistoryItem(title: "Comeu \(selectedMealCategory.displayText)", author: author, date: Date(), type: .meal, to: careRecipient)
        
    }
    
    private func getCurrentCareRecipient() -> CareRecipient? {
        userService.fetchCurrentPatient()
    }
}
