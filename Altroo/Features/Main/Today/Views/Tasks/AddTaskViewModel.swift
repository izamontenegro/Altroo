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
    var currentCareRecipient: CareRecipient
    
    @Published var name: String = ""
    @Published var times: [Date] = []
    @Published var repeatingDays: [Locale.Weekday] = []
    @Published var startDate: Date = .now
    @Published var endDate: Date = .now
    @Published var note: String = ""
    
    @Published var isContinuous: Bool = true
    let continuousOptions = ["Continuous", "End Date"]
    var continuousButtonTitle: String {
        if isContinuous {
            continuousOptions[0]
        } else {
            continuousOptions[1]
        }
    }
    
    init(taskService: RoutineActivitiesFacade) {
        self.taskService = taskService
        
        //Test person
        //        let stack = CoreDataStack.shared
        //        let service = CoreDataService(stack: stack)
        //
        //        let personalData = PersonalData(context: stack.context)
        //        personalData.name = "Mrs. Parente"
        //        let recipient = CareRecipient(context: stack.context)
        //        recipient.personalData = personalData
        //        let routineAct = RoutineActivities(context: stack.context)
        //        routineAct.tasks = []
        //        recipient.routineActivities = routineAct
        //
        //        service.save()
        
        currentCareRecipient = CoreDataService(stack: CoreDataStack.shared).fetchAllCareRecipients().first(where: { $0.personalData?.name == "Mrs. Parente" })!
    }
    
    //MARK: VALIDATION
    //    func isTexfieldEmpty() -> Bool {
    //
    //    }
    
    var finalEndDate: Date? {
        if isContinuous == true { return nil } else { return endDate }
    }
    
    func checkRepeatingDays() {
        if repeatingDays.isEmpty {
            repeatingDays = Locale.Weekday.allCases
        }
    }
    
    //MARK: FORMATTING
    
    
    //MARK: CREATION
    func generateTaskDates() -> [Date] {
        var generatedDates: [Date] = []
        let calendar = Calendar.current
        
        guard !times.isEmpty else { return [] }
        
        //TODO: Logic to regenerate tasks once this period ends
        let end = isContinuous
        ? calendar.date(byAdding: .month, value: 3, to: startDate) ?? startDate //generates task instances for 3 months
        : endDate
        
        checkRepeatingDays()
        
        //range
        var currentDate = calendar.startOfDay(for: startDate)
        let finalDate = calendar.startOfDay(for: end)
        
        while currentDate <= finalDate {
            //conversion from calendar weekday(int) to enum Locale.weekday
            guard let weekday = Locale.Weekday.from(calendarWeekday: calendar.component(.weekday, from: currentDate)) else {
                continue
            }
            guard repeatingDays.contains(weekday) else { continue }
            
            for time in times {
                //final date -> date + time
                let hour = calendar.component(.hour, from: time)
                let minute = calendar.component(.minute, from: time)
                if let combinedDate = calendar.date(bySettingHour: hour, minute: minute, second: 0, of: currentDate) {
                    generatedDates.append(combinedDate)
                }
            }
            
            guard let nextDay = calendar.date(byAdding: .day, value: 1, to: currentDate) else { break }
            currentDate = nextDay
        }
        return generatedDates
    }

    func createTaskUnit(time: Date) {
        taskService.addRoutineTask(name: name, time: time, daysOfTheWeek: repeatingDays, startDate: startDate, endDate: finalEndDate, reminder: false, note: note, in: currentCareRecipient)
        print(currentCareRecipient.routineActivities?.tasks)
    }
    
    func createAllTasks() {
        let allDates = generateTaskDates()
        
        for time in allDates {
            createTaskUnit(time: time)
        }
    }
}
