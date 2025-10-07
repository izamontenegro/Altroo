//
//  TaskService.swift
//  Altroo
//
//  Created by Layza Maria Rodrigues Carneiro on 02/10/25.
//

import Foundation

protocol TaskServiceProtocol {
    
    func addTask(name: String, period: PeriodEnum, time: Date, frequency: FrequencyEnum, reminder: Bool, note: String, in careRecipient: CareRecipient)
    
    func deleteTask(task: Task, from careRecipient: CareRecipient)
    
}

class TaskService: TaskServiceProtocol {
    func addTask(name: String, period: PeriodEnum, time: Date, frequency: FrequencyEnum, reminder: Bool, note: String, in careRecipient: CareRecipient) {
        
        guard let context = careRecipient.managedObjectContext else { return }
        let newTask = Task(context: context)
        
        newTask.name = name
        newTask.period = period.rawValue
        newTask.time = time
        newTask.frequency = frequency.rawValue
        newTask.reminder = reminder
        newTask.note = note

        
        if let healthProblemsTasks = careRecipient.healthProblems?.diseases {
            let mutableTask = healthProblemsTasks.mutableSetValue(forKey: "task")
            mutableTask.add(newTask)
        }
    }
    
    func deleteTask(task: Task, from careRecipient: CareRecipient) {
        if let healthProblemsTasks = careRecipient.healthProblems?.diseases {
            let mutableTask = healthProblemsTasks.mutableSetValue(forKey: "task")
            mutableTask.remove(task)
        }
    }
}
