//
//  RoutineTaskService.swift
//  Altroo
//
//  Created by Layza Maria Rodrigues Carneiro on 02/10/25.
//

import Foundation

protocol RoutineTaskServiceProtocol {
    
    func addRoutineTask(name: String, time: Date, daysOfTheWeek: [Locale.Weekday], startDate: Date, endDate: Date?, reminder: Bool, note: String, in careRecipient: CareRecipient)
    
    func deleteRoutineTask(routineTask: RoutineTask, from careRecipient: CareRecipient)
    
    func fetchRoutineTasks(for careRecipient: CareRecipient) -> [RoutineTask]
    
}

class RoutineTaskService: RoutineTaskServiceProtocol {
    func addRoutineTask(name: String, time: Date, daysOfTheWeek: [Locale.Weekday], startDate: Date, endDate: Date?, reminder: Bool, note: String, in careRecipient: CareRecipient) {
        
        guard let context = careRecipient.managedObjectContext else { return }
        
        let newRoutineTask = RoutineTask(context: context)
        newRoutineTask.name = name
        newRoutineTask.time = time
        newRoutineTask.startDate = startDate
        newRoutineTask.reminder = reminder
        newRoutineTask.note = note

        if let routineActivities = careRecipient.routineActivities {
            let mutableRoutineTask = routineActivities.mutableSetValue(forKey: "tasks")
            mutableRoutineTask.add(newRoutineTask)
        }
    }
    
    func deleteRoutineTask(routineTask: RoutineTask, from careRecipient: CareRecipient) {
        if let routineActivities = careRecipient.routineActivities?.tasks {
            let mutableRoutineTask = routineActivities.mutableSetValue(forKey: "tasks")
            mutableRoutineTask.remove(routineTask)
        }
    }
    
    func fetchRoutineTasks(for careRecipient: CareRecipient) -> [RoutineTask] {
        guard let routineActivities = careRecipient.routineActivities,
              let tasks = routineActivities.tasks as? Set<RoutineTask> else {
            return []
        }
        return Array(tasks)
    }
}
