//
//  AllTasksViewModel.swift
//  Altroo
//
//  Created by Raissa Parente on 07/10/25.
//
import Foundation
import Combine

class AllTasksViewModel {
    var taskService: RoutineActivitiesFacade
    var currentCareRecipient: CareRecipient?
    let userService: UserServiceProtocol
    
    let coreDataService: CoreDataService
    let historyService: HistoryService
    

    @Published var tasks: [TaskInstance] = []
  
    init(taskService: RoutineActivitiesFacade, userService: UserServiceProtocol, coreDataService: CoreDataService, historyService: HistoryService) {
        self.taskService = taskService
        self.userService = userService
        self.coreDataService = coreDataService
        self.historyService = historyService

        fetchCareRecipient()
        loadTasks()
    }
    
    func fetchCareRecipient() {
        currentCareRecipient = userService.fetchCurrentPatient()
    }
    
    func loadTasks() {
        guard let careRecipient = currentCareRecipient else { return }

        taskService.generateInstancesForToday(for: careRecipient)
        let allTasks = taskService.fetchAllInstanceRoutineTasks(from: careRecipient)
        tasks = filterTasksByDay(allTasks)
    }
    
    func filterTasksByPeriod(_ period: PeriodEnum) -> [TaskInstance] {
        return tasks
            .filter({$0.period == period})
            .sorted(by: {$0.time! < $1.time!})
    }
    
    func filterTasksByDay(_ tasks: [TaskInstance]) -> [TaskInstance] {
        let today = Calendar.current.startOfDay(for: Date())
        let todayDayOfTheWeek = Locale.Weekday.from(calendarWeekday: Calendar.current.component(.weekday, from: today))
        
        //filter by task interval
        let intervalTasks = tasks.filter { task in
            guard let start = task.template?.startDate else { return false }
            
            let end = task.template?.endDate //will be nil if continuous

            let isAfterStart = start <= today
            let isBeforeEnd = end == nil || end! >= today

            return isAfterStart && isBeforeEnd
        }
        
        //filter by weekday
        let weekdayTasks = intervalTasks.filter { task in
            
            guard let todayWeek = todayDayOfTheWeek else { return false }
            return task.template?.weekdays.contains(todayWeek) ?? false
        }
        return weekdayTasks
    }
    
    func markAsDone(_ instance: TaskInstance) {
        guard
            let careRecipient = userService.fetchCurrentPatient()
        else { return }
        
        taskService.toggleInstanceIsDone(instance)
        
        let author = coreDataService.currentPerformerName(for: careRecipient)
        
        historyService.addHistoryItem(title: "Realizou \(instance.template?.name ?? "tarefa.")", author: author, date: Date(), to: careRecipient)
    }
}
