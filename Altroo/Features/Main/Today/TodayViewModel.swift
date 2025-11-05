//
//  TodayViewModel.swift
//  Altroo
//
//  Created by Raissa Parente on 13/10/25.
//

import Combine
import Foundation

class TodayViewModel {
    
    let careRecipientFacade: CareRecipientFacade
    let basicNeedsFacade: BasicNeedsFacade
    let userService: UserServiceProtocol
    let coreDataService: CoreDataService
    let historyService: HistoryService
    var taskService: RoutineActivitiesFacade
    
    var currentCareRecipient: CareRecipient?
    
    @Published var todaySymptoms: [Symptom] = []
    @Published var periodTasks: [TaskInstance] = []
    
    @Published var todayStoolQuantity: Int = 0
    @Published var todayUrineQuantity: Int = 0
    @Published var waterQuantity: Double = 0.0
    @Published var waterMeasure: Double = 0.0
        
    init(careRecipientFacade: CareRecipientFacade, basicNeedsFacade: BasicNeedsFacade, userService: UserServiceProtocol, taskService: RoutineActivitiesFacade, coreDataService: CoreDataService, historyService: HistoryService) {
        self.careRecipientFacade = careRecipientFacade
        self.basicNeedsFacade = basicNeedsFacade
        self.userService = userService
        self.taskService = taskService
        self.coreDataService = coreDataService
        self.historyService = historyService
        
        fetchCareRecipient()
        fetchAllTodaySymptoms()
        fetchAllPeriodTasks()
        fetchUrineQuantity()
        fetchStoolQuantity()
        fetchWaterMeasure()
    }
    
    private func fetchCareRecipient() {
        currentCareRecipient = userService.fetchCurrentPatient() ?? userService.fetchPatients().last
    }
    
    func fetchAllTodaySymptoms() {
        guard let currentCareRecipient = currentCareRecipient else { return }
        todaySymptoms = careRecipientFacade.fetchAllSymptomForDate(.now, from: (currentCareRecipient))
    }
    
    func fetchAllPeriodTasks() {
        guard let currentCareRecipient else { return }
        
        taskService.generateInstancesForToday(for: currentCareRecipient)
        let allTasks = taskService.fetchAllInstanceRoutineTasks(from: currentCareRecipient)
        
        let currentPeriod = PeriodEnum.current
        let today = Date()
        let todayWeekday = Locale.Weekday.from(calendarWeekday: Calendar.current.component(.weekday, from: today))
        
        periodTasks = allTasks.filter { task in
            guard let start = task.template?.startDate else { return false }
            let end = task.template?.endDate
            
            let isTodayInInterval = start <= today && (end == nil || end! >= today)
            let isTodayWeekday = task.template?.weekdays.contains(todayWeekday ?? .monday) ?? false
            let isCurrentPeriod = task.period == currentPeriod
            
            return isTodayInInterval && isTodayWeekday && isCurrentPeriod
        }
        .sorted(by: { $0.time ?? .distantPast < $1.time ?? .distantPast })
    }
    
    func markAsDone(_ instance: TaskInstance) {
        guard let careRecipient = userService.fetchCurrentPatient() else { return }
        let author = coreDataService.currentPerformerName(for: careRecipient)
        taskService.toggleInstanceIsDone(instance, author: author, time: .now)
    }
    
    func fetchUrineQuantity() {
        guard let currentCareRecipient = currentCareRecipient else { return }
        
        let calendar = Calendar.current
        let today = Date()
        
        let todayUrine = currentCareRecipient.basicNeeds?.urine?.filter { urineRecord in
            calendar.isDate((urineRecord as AnyObject).date ?? Date(), inSameDayAs: today)
        }
        
        todayUrineQuantity = todayUrine?.count ?? 0
    }
    
    func fetchStoolQuantity() {
        guard let currentCareRecipient = currentCareRecipient else { return }
        
        let calendar = Calendar.current
        let today = Date()
        
        let todayStool = currentCareRecipient.basicNeeds?.stool?.filter { stoolRecord in
            calendar.isDate((stoolRecord as AnyObject).date ?? Date(), inSameDayAs: today)
        }
        
        todayStoolQuantity = todayStool?.count ?? 0
    }
    
    func fetchFeedingRecords() -> [FeedingRecord] {
        guard let currentCareRecipient = currentCareRecipient else { return [] }
        
        let calendar = Calendar.current
        let today = Date()
        
        let todayFeedings = currentCareRecipient.basicNeeds?.feeding?
            .compactMap { $0 as? FeedingRecord }
            .filter { record in
                guard let date = record.date else { return false }
                return calendar.isDate(date, inSameDayAs: today)
            }
            .sorted { ($0.date ?? Date()) > ($1.date ?? Date()) } ?? []
        
        return todayFeedings
    }
    
    func fetchWaterQuantity() {
        guard let currentCareRecipient = currentCareRecipient else { return }
        
        let calendar = Calendar.current
        let today = Date()
        
        let todayHydration = currentCareRecipient.basicNeeds?.hydration?.filter { hydrationRecord in
            guard let recordDate = (hydrationRecord as AnyObject).date as? Date else { return false }
            return calendar.isDate(recordDate, inSameDayAs: today)
        }
        
        let totalWater = todayHydration?.reduce(0) { sum, hydrationRecord in
            let quantity = (hydrationRecord as AnyObject).waterQuantity ?? 0
            return sum + quantity
        } ?? 0
        
        self.waterQuantity = totalWater / 1000
    }
    
    // func to save a hydration record
    func saveHydrationRecord() {
        guard
            let careRecipient = userService.fetchCurrentPatient()
        else { return }
        
        let author = coreDataService.currentPerformerName(for: careRecipient)
                
        basicNeedsFacade.addHydration(
            period: PeriodEnum.current,
            date: Date(),
            waterQuantity: careRecipientFacade.getWaterMeasure(careRecipient), author: author,
            in: careRecipient
        )
    
        historyService.addHistoryItem(title: "Bebeu \(careRecipientFacade.getWaterMeasure(careRecipient))ml de água", author: author, date: Date(), type: .hydration, to: careRecipient)
        
        self.fetchWaterQuantity()
    }
    
    func fetchWaterMeasure() {
        guard let careRecipient = currentCareRecipient else { return }
        waterMeasure = careRecipientFacade.getWaterMeasure(careRecipient)
    }

    func getWaterTarget() -> Double {
        guard let careRecipient = currentCareRecipient else { return 0 }
        return careRecipientFacade.getWaterTarget(careRecipient)
    }
    
}
