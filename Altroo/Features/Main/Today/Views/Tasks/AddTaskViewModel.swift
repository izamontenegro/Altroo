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
    
    func createTaskUnit(time: Date) {
        taskService.addRoutineTask(name: name, time: time, daysOfTheWeek: repeatingDays, startDate: startDate, endDate: endDate, reminder: false, note: note, in: currentCareRecipient)
        print(currentCareRecipient.routineActivities?.tasks)
    }
    
    func createAllTasks() {
        for time in times {
            createTaskUnit(time: time)
        }
    }
}
