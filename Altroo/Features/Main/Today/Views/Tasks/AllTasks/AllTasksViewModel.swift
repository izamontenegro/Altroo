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
        return tasks.filter { task in
             Calendar.current.isDateInToday(task.time ?? .now)
        }
    }

    func markAsDone(_ instance: TaskInstance) {
        guard let careRecipient = userService.fetchCurrentPatient() else { return }
        
        let author = coreDataService.currentPerformerName(for: careRecipient)
        
        taskService.toggleInstanceIsDone(instance, author: author, time: .now)

        historyService.addHistoryItem(title: "Realizou \(instance.template?.name ?? "tarefa")", author: author, date: Date(), type: .task, to: careRecipient)
    }
}
