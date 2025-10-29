//
//  EditTaskViewModel.swift
//  Altroo
//
//  Created by Raissa Parente on 16/10/25.
//
import Combine
import Foundation

class EditTaskViewModel {
    var task: RoutineTask
    var taskService: RoutineActivitiesFacade
    var currentCareRecipient: CareRecipient?
    let userService: UserServiceProtocol
    
    @Published var name: String = ""
    @Published var times: [DateComponents] = []
    @Published var repeatingDays: [Locale.Weekday] = []
    @Published var startDate: Date = .now
    @Published var endDate: Date?
    @Published var note: String = ""
    
    @Published var nameError: String?
    
    @Published var isContinuous: Bool = false
    
    let continuousOptions = ["Contínuo", "Data Final"]
    var continuousButtonTitle: String {
        if isContinuous {
            continuousOptions[0]
        } else {
            continuousOptions[1]
        }
    }
        
    private let validator = FormValidator()
    
    init(task: RoutineTask, taskService: RoutineActivitiesFacade, userService: UserServiceProtocol) {
        self.task = task
        self.taskService = taskService
        self.userService = userService

        fetchCareRecipient()
        updateFields()
    }
    
    func addTime(from date: Date, at index: Int? = nil) {
            let calendar = Calendar.current
            let comp = DateComponents(
                hour: calendar.component(.hour, from: date),
                minute: calendar.component(.minute, from: date)
            )
        
        if let index {
            times[index] = comp
        } else {
            times.append(comp)
        }
    }
    
    private func updateFields() {
        name = task.name!
        times = task.allTimes ?? []
        startDate = task.startDate ?? .now
        endDate = task.endDate ?? nil
        note = task.note ?? ""
        isContinuous = task.endDate == nil ? true : false
        repeatingDays = task.weekdays
    }

    func fetchCareRecipient() {
        currentCareRecipient = userService.fetchCurrentPatient()
    }
    
    func updateTask() -> Bool {
        guard validator.isEmpty(name, error: &nameError) else { return false }
                
        taskService.editTemplateRoutineTask(task: task, name: name, allTimes: times, daysOfTheWeek: repeatingDays, startDate: startDate, endDate: endDate, reminder: false, note: note)
        
        return true
    }
    
    func deleteTask() {
        guard let currentCareRecipient else { return }
        taskService.deleteRoutineTask(routineTask: task, from: currentCareRecipient)
    }
    
}
