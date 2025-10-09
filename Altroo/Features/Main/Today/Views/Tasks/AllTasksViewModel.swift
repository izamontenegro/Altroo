//
//  AllTasksViewModel.swift
//  Altroo
//
//  Created by Raissa Parente on 07/10/25.
//
import Foundation
import Combine

struct MockTask {
    var name: String?
    var note: String?
    var reminder: Bool?
    var time: Date?
    var daysOfTheWeek: [Locale.Weekday]?
    var startDate: Date?
    var endDate: Date?
    
    var period: PeriodEnum {
        
        let hour = Calendar.current.component(.hour, from: time!)
        
        switch hour {
        case 5..<12:
            return .morning
        case 12..<17:
            return .afternoon
        case 17..<21:
            return .evening
        default:
            return .night
        }
    }
}

let cloudkitTasks: [MockTask] = [
//    MockTask(
//        name: "Administer medications",
//        note: "Check medication log for proper dosage and timing.",
//        reminder: true,
//        time: Calendar.current.date(from: DateComponents(hour: 7, minute: 30))!,
//        daysOfTheWeek: [.friday, .sunday],
//        startDate: Calendar.current.date(from: DateComponents(year: 2025, month: 10, day: 10))!,
//        endDate: Calendar.current.date(from: DateComponents(year: 2025, month: 12, day: 31))!
//    ),
//    MockTask(
//        name: "Assist with personal hygiene",
//        note: "Help with bathing, getting dressed, and brushing teeth.",
//        reminder: true,
//        time: Calendar.current.date(from: DateComponents(hour: 9, minute: 0))!,
//        daysOfTheWeek: [.monday, .wednesday, .friday],
//        startDate: Calendar.current.date(from: DateComponents(year: 2025, month: 10, day: 11))!,
//        endDate: Calendar.current.date(from: DateComponents(year: 2026, month: 1, day: 5))!
//    ),
    MockTask(
        name: "Prepare and serve lunch",
        note: "Ensure meal is balanced and follows any dietary restrictions.",
        reminder: true,
        time: Calendar.current.date(from: DateComponents(hour: 13, minute: 0))!,
        daysOfTheWeek: [.friday, .sunday],
        startDate: Calendar.current.date(from: DateComponents(year: 2025, month: 10, day: 9))!,
        endDate: Calendar.current.date(from: DateComponents(year: 2025, month: 12, day: 25))!
    ),
    MockTask(
        name: "Dinner",
        note: "Prepare and serve dinner, and assist with cleanup.",
        reminder: true,
        time: Calendar.current.date(from: DateComponents(hour: 18, minute: 30))!,
        daysOfTheWeek: [.thursday],
        startDate: Calendar.current.date(from: DateComponents(year: 2025, month: 10, day: 8))!,
        endDate: Calendar.current.date(from: DateComponents(year: 2025, month: 11, day: 30))!
    ),
    MockTask(
        name: "Ensure home is secure",
        note: "Lock doors, turn off lights, and set the alarm.",
        reminder: true,
        time: Calendar.current.date(from: DateComponents(hour: 22, minute: 0))!,
        daysOfTheWeek: [.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday],
        startDate: Calendar.current.date(from: DateComponents(year: 2025, month: 10, day: 10))!,
        endDate: Calendar.current.date(from: DateComponents(year: 2026, month: 1, day: 10))!
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
            .sorted(by: {$0.time! < $1.time!})
    }
}
