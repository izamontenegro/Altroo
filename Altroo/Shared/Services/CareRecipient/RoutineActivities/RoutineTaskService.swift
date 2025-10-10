//
//  RoutineTaskService.swift
//  Altroo
//
//  Created by Layza Maria Rodrigues Carneiro on 02/10/25.
//

import Foundation

protocol RoutineTaskServiceProtocol {
    
    func addRoutineTask(name: String, period: PeriodEnum, time: Date, frequency: FrequencyEnum, reminder: Bool, note: String, in careRecipient: CareRecipient)
    
    func deleteRoutineTask(routineTask: RoutineTask, from careRecipient: CareRecipient)
    
}

//TODO: Add startdate enddate
class RoutineTaskService: RoutineTaskServiceProtocol {
    func addRoutineTask(name: String, period: PeriodEnum, time: Date, frequency: FrequencyEnum, reminder: Bool, note: String, in careRecipient: CareRecipient) {
        
        guard let context = careRecipient.managedObjectContext else { return }
        
        let newRoutineTask = RoutineTask(context: context)
        newRoutineTask.name = name
        newRoutineTask.time = time
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
}
