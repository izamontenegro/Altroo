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
    let userService: UserServiceProtocol
    var taskService: RoutineActivitiesFacade
    
    var currentCareRecipient: CareRecipient?
    
    @Published var todaySymptoms: [Symptom] = []
    @Published var periodTasks: [TaskInstance] = []
    
    @Published var todayStoolQuantity: Int = 0
    @Published var todayUrineQuantity: Int = 0
    @Published var WaterQuantity: Double = 0
    
    init(careRecipientFacade: CareRecipientFacade, userService: UserServiceProtocol, taskService: RoutineActivitiesFacade) {
        self.careRecipientFacade = careRecipientFacade
        self.userService = userService
        self.taskService = taskService
        
        fetchCareRecipient()
        fetchAllTodaySymptoms()
        fetchAllPeriodTasks()
        fetchUrineQuantity()
        fetchStoolQuantity()
    }
    
    private func fetchCareRecipient() {
        currentCareRecipient = userService.fetchCurrentPatient()
    }
    
    func fetchAllTodaySymptoms() {
        todaySymptoms = careRecipientFacade.fetchAllSymptomForDate(.now, from: currentCareRecipient!)
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
    
    func fetchFeedingRecords() {
        guard let currentCareRecipient = currentCareRecipient else { return }

        let records = currentCareRecipient.basicNeeds?.feeding
    }
    
    func fetchWaterQuantity() {
        guard let currentCareRecipient = currentCareRecipient else { return }
        
        let calendar = Calendar.current
        let today = Date()
        
        let todayHydration = currentCareRecipient.basicNeeds?.hydration?.filter { hydrationRecord in
            calendar.isDate((hydrationRecord as AnyObject).date ?? Date(), inSameDayAs: today)
        }
        
//        WaterQuantity = todayHydration ?? 0
    }
    
    func markAsDone(_ instance: TaskInstance) {
        taskService.toggleInstanceIsDone(instance)
    }
}
