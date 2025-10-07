//
//  AllTasksViewModel.swift
//  Altroo
//
//  Created by Raissa Parente on 07/10/25.
//
import Foundation
import Combine

struct MockTask {
    var name: String
    var note: String
    var period: PeriodEnum
    var frequency: String
    var reminder: Bool
    var time: Date
    var daysOfTheWeek: [Locale.Weekday]
}

let cloudkitTasks: [MockTask] = [
    MockTask(
        name: "Administer medications",
        note: "Check medication log for proper dosage and timing.",
        period: .morning,
        frequency: "Daily",
        reminder: true,
        time: Date(),
        daysOfTheWeek: [.friday, .sunday]
    ),
    MockTask(
        name: "Assist with personal hygiene",
        note: "Help with bathing, getting dressed, and brushing teeth.",
        period: .morning,
        frequency: "Daily",
        reminder: true,
        time: Date(),
        daysOfTheWeek: [.monday, .wednesday, .friday]
    ),
    MockTask(
        name: "Prepare and serve lunch",
        note: "Ensure meal is balanced and follows any dietary restrictions.",
        period: .afternoon,
        frequency: "Daily",
        reminder: true,
        time: Date(),
        daysOfTheWeek: [.friday, .sunday]
    ),
    MockTask(
        name: "Dinner",
        note: "Prepare and serve dinner, and assist with cleanup.",
        period: .evening,
        frequency: "Daily",
        reminder: true,
        time: Date(),
        daysOfTheWeek: [.thursday]
    ),
    MockTask(
        name: "Ensure home is secure",
        note: "Lock doors, turn off lights, and set the alarm.",
        period: .night,
        frequency: "Daily",
        reminder: true,
        time: Date(),
        daysOfTheWeek: [.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]
    )
]

class AllTasksViewModel {
    @Published var tasks: [MockTask] = []

//    private let taskService: TaskService
//    
//    init(taskService: TaskService) {
//        self.taskService = taskService
//    }
    
    init() {
        loadTasks()
    }
    
    func loadTasks() {
        tasks = cloudkitTasks
    }
    
    func filterTasksByPeriod(_ period: PeriodEnum) -> [MockTask] {
        return tasks.filter({$0.period == period})
            .sorted(by: {$0.time < $1.time})
    }
}
