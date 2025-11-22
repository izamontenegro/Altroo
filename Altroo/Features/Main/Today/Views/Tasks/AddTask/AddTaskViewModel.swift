//
//  AddTaskViewModel.swift
//  Altroo
//
//  Created by Raissa Parente on 08/10/25.
//
import Combine
import Foundation
import UIKit

class AddTaskViewModel {
    var taskService: RoutineActivitiesFacade
    var currentCareRecipient: CareRecipient?
    let userService: UserServiceProtocol
    
    @Published var name: String = ""
    @Published var times: [DateComponents] = []
    @Published var repeatingDays: [Locale.Weekday] = []
    @Published var startDate: Date = .now
    @Published var endDate: Date?
    @Published var note: String = ""
    
    private let validator = FormValidator()
    @Published private(set) var fieldErrors: [String: String] = [:]

    @Published var isContinuous: Bool = true
    let continuousOptions = ["Sem data final", "Com data final"]
    var continuousButtonTitle: String {
        if isContinuous {
            continuousOptions[0]
        } else {
            continuousOptions[1]
        }
    }
    
    init(taskService: RoutineActivitiesFacade, userService: UserServiceProtocol) {
        self.taskService = taskService
        self.userService = userService

        fetchCareRecipient()
    }

    func fetchCareRecipient() {
        currentCareRecipient = userService.fetchCurrentPatient()
    }
    
    var finalEndDate: Date? {
        isContinuous ? nil : endDate
    }
    
    func checkRepeatingDays() {
        if repeatingDays.isEmpty {
            repeatingDays = Locale.Weekday.allWeekDays
        }
    }
    
    func validateTask() -> Bool {
        var newErrors: [String: String] = [:]

        _ = validator.isEmpty(name, error: &newErrors["name"])
        
        if let endDate {
            _ = validator.invalidDateRange(startDate: startDate, endDate: endDate, error: &newErrors["date"])
        }
        
        fieldErrors = newErrors
        return newErrors.isEmpty
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
        
    
    //MARK: CREATION
    func createTask() {
        guard let careRecipient = currentCareRecipient else { return }
        
        checkRepeatingDays()
        
        taskService.addTemplateRoutineTask(
            name: name,
            allTimes: times,
            daysOfTheWeek: repeatingDays,
            startDate: startDate,
            endDate: finalEndDate,
            reminder: false,
            note: note,
            in: careRecipient)
        
    }
}
