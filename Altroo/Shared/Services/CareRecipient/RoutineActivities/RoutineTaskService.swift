//
//  RoutineTaskService.swift
//  Altroo
//
//  Created by Layza Maria Rodrigues Carneiro on 02/10/25.
//

import Foundation
import CoreData

protocol RoutineTaskServiceProtocol {
    
    //template
    func addTemplateRoutineTask(name: String, allTimes: [DateComponents], daysOfTheWeek: [Locale.Weekday], startDate: Date, endDate: Date?, reminder: Bool, note: String, in careRecipient: CareRecipient)
    
    func deleteRoutineTask(routineTask: RoutineTask, from careRecipient: CareRecipient)
    
    func fetchRoutineTasks(for careRecipient: CareRecipient) -> [RoutineTask]
    
    
    //instance
    func fetchInstanceRoutineTasks(for careRecipient: CareRecipient) -> [TaskInstance]
    
    func addInstanceRoutineTask(from template: RoutineTask, on date: Date)
    
    func markInstanceAsDone(_ instance: TaskInstance)
    
    func deleteInstanceRoutineTask(_ instance: TaskInstance)
    
}

class RoutineTaskService: RoutineTaskServiceProtocol {
    func addTemplateRoutineTask(name: String,
                                allTimes: [DateComponents],
                                daysOfTheWeek: [Locale.Weekday],
                                startDate: Date, endDate: Date?, //optional end for continous tasks
                                reminder: Bool,
                                note: String, in
                                careRecipient: CareRecipient) {
        
        guard let context = careRecipient.managedObjectContext else { return }
        
        //normalization for instance making
        let todayStart = Calendar.current.startOfDay(for: Date())
        
        let newRoutineTask = RoutineTask(context: context)
        newRoutineTask.name = name
        newRoutineTask.allTimes = allTimes
        newRoutineTask.startDate = todayStart
        newRoutineTask.endDate = endDate
        newRoutineTask.reminder = reminder
        newRoutineTask.weekdays = daysOfTheWeek
        newRoutineTask.note = note
        
        if let routineActivities = careRecipient.routineActivities {
            let mutableRoutineTask = routineActivities.mutableSetValue(forKey: "tasks")
            mutableRoutineTask.add(newRoutineTask)
        }
    }
    
    func deleteRoutineTask(routineTask: RoutineTask, from careRecipient: CareRecipient) {
        //TODO: understand why was relationship and not coredata instance deleted
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
    
    func addInstanceRoutineTask(from template: RoutineTask, on date: Date) {
        guard let context = template.managedObjectContext else { return }
        guard let allTimes = template.allTimes else { return }
        
        for timeComp in allTimes {
            let instance = TaskInstance(context: context)
            instance.time = Calendar.current.date(
                bySettingHour: timeComp.hour!,
                minute: timeComp.minute!,
                second: 0,
                of: date
            )!
            instance.isDone = false
            instance.template = template
        }
    }
    
    func markInstanceAsDone(_ instance: TaskInstance) {
        instance.isDone = true
    }

    func fetchInstanceRoutineTasks(for careRecipient: CareRecipient) -> [TaskInstance] {
        guard let context = careRecipient.managedObjectContext else { return [] }

        let request: NSFetchRequest<TaskInstance> = TaskInstance.fetchRequest()
        request.predicate = NSPredicate(format: "template.routineActivities == %@", careRecipient.routineActivities!)
        request.sortDescriptors = [NSSortDescriptor(key: "time", ascending: true)]
        
        return (try? context.fetch(request)) ?? []
    }

    func deleteInstanceRoutineTask(_ instance: TaskInstance) {
        guard let context = instance.managedObjectContext else { return }
            
        context.delete(instance)
    }
}
