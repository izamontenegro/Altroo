//
//  MealRecordViewModel.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 19/10/25.
//
import UIKit
import Combine

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
            period: PeriodEnum.afternoon,
            notes: notes,
            mealCategory: selectedMealCategory,
            in: careRecipient
        )
    }

    private func getCurrentCareRecipient() -> CareRecipient? {
        userService.fetchCurrentPatient()
    }
}
