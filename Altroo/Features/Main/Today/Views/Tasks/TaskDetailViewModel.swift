//
//  TaskDetailViewModel.swift
//  Altroo
//
//  Created by Raissa Parente on 19/11/25.
//
import Foundation

class TaskDetailViewModel {
    var taskService: RoutineActivitiesFacade
    let userService: UserServiceProtocol
    
    var currentCareRecipient: CareRecipient?
  
    init(taskService: RoutineActivitiesFacade, userService: UserServiceProtocol) {
        self.taskService = taskService
        self.userService = userService

        fetchCareRecipient()
    }
    
    func fetchCareRecipient() {
        currentCareRecipient = userService.fetchCurrentPatient()
    }
    
    func deleteTask(_ task: RoutineTask) {
        guard let careRecipient = userService.fetchCurrentPatient() else { return }
        taskService.deleteRoutineTask(routineTask: task, from: careRecipient)
    }
}
