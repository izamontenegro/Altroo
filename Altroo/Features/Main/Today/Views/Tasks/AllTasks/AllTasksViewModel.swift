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
    @Published var lateTasks: [TaskInstance] = []
    @Published var upcomingTasks: [RoutineTask] = []
  
    init(taskService: RoutineActivitiesFacade, userService: UserServiceProtocol, coreDataService: CoreDataService, historyService: HistoryService) {
        self.taskService = taskService
        self.userService = userService
        self.coreDataService = coreDataService
        self.historyService = historyService

        fetchCareRecipient()
        loadTodayTasks()
        loadLateTasks()
        loadFutureTasks()
    }
    
    func fetchCareRecipient() {
        currentCareRecipient = userService.fetchCurrentPatient()
    }
    
    //MARK: -TODAY TASKS
    func loadTodayTasks() {
        guard let careRecipient = currentCareRecipient else { return }

        taskService.generateInstancesForToday(for: careRecipient)
        let allTasks = taskService.fetchAllInstanceRoutineTasks(from: careRecipient)
        tasks = filterTodayTasks(allTasks)
    }
    
    func filterTasksByPeriod(_ period: PeriodEnum) -> [TaskInstance] {
        return tasks
            .filter({$0.period == period})
            .sorted(by: {$0.time! < $1.time!})
    }
    
    func filterTodayTasks(_ tasks: [TaskInstance]) -> [TaskInstance] {
        return tasks.filter { task in
             Calendar.current.isDateInToday(task.time ?? .now)
        }
    }
    
    //MARK: -LATE TASKS
    func loadLateTasks()  {
        guard let careRecipient = currentCareRecipient else { return }
        let allTasks = taskService.fetchAllInstanceRoutineTasks(from: careRecipient)

        lateTasks = allTasks.filter( { $0.isLateDay })
    }
    
    var daysOfLateTasks: [Date] {
        let days = lateTasks
               .compactMap { $0.time }
               .map { Calendar.current.startOfDay(for: $0) }
        
        return Array(Set(days))
            .sorted(by: { $0 > $1 })
    }
    
    func filterLateTasksByDay(_ day: Date) -> [TaskInstance] {
        return lateTasks
            .filter({ Calendar.current.isDate($0.time!, inSameDayAs: day) })
            .sorted(by: {$0.time! < $1.time!})
    }
    
    //MARK: -FUTURE TASKS
    func loadFutureTasks() {
        guard let careRecipient = currentCareRecipient else { return }
        let allTasks = taskService.fetchAllTemplateRoutineTasks(from: careRecipient)
        
        upcomingTasks = allTasks
            .filter { task in
                if let end = task.endDate {
                    return Calendar.current.startOfDay(for: end) > Calendar.current.startOfDay(for: .now)
                } else {
                    return true
                }
            }
    }
    
    //MARK: -UTILS
    func markAsDone(_ instance: TaskInstance) {
        guard let careRecipient = userService.fetchCurrentPatient() else { return }
        
        let author = coreDataService.currentPerformerName(for: careRecipient)
        
        taskService.toggleInstanceIsDone(instance, author: author, time: .now)

        historyService.addHistoryItem(title: "Realizou \(instance.template?.name ?? "tarefa")", author: author, date: Date(), type: .task, to: careRecipient)
    }
}
