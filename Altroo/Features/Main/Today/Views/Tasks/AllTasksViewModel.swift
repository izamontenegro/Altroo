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
    var taskService: RoutineActivitiesFacade
    var currentCareRecipient: CareRecipient
    
    @Published var tasks: [TaskInstance] = []
  
    init(taskService: RoutineActivitiesFacade,
         currentCareRecipient: CareRecipient =  CoreDataService(stack: CoreDataStack.shared).fetchAllCareRecipients().first(where: { $0.personalData?.name == "Mrs. Parente" })!) {
        self.taskService = taskService
        
        //FIXME: SWAP FOR REAL INJECTED CARERECIPIENT
        self.currentCareRecipient = currentCareRecipient
        
        loadTasks()
    }
    
    func loadTasks() {
        taskService.generateInstancesForToday(for: currentCareRecipient)
        let allTasks = taskService.fetchAllInstanceRoutineTasks(from: currentCareRecipient)
        
        print("DEBUG: fetchAllInstanceRoutineTasks returned \(allTasks.count) instances total")
            for inst in allTasks {
                let tmplName = inst.template?.name ?? "NO_TEMPLATE"
                let tmplStart = inst.template?.startDate?.description(with: .current) ?? "nil"
                let tmplEnd = inst.template?.endDate?.description(with: .current) ?? "nil"
                let tmplWeekdays = inst.template?.weekdays ?? []
                let instTime = inst.time?.description(with: .current) ?? "nil"
                print("DEBUG: instance '\(tmplName)' — instance.time: \(instTime) — template.start: \(tmplStart) — template.end: \(tmplEnd) — weekdays: \(tmplWeekdays)")
            }
        
        tasks = filterTasksByDay(allTasks)
        
        if tasks.isEmpty {
            print("Nao tem tasks hj")
        } else {
            for t in tasks {
                print("Instância: \(t.template!.name ?? "") às \(t.time ?? Date())")
            }
        }
    }
    
    func filterTasksByPeriod(_ period: PeriodEnum) -> [TaskInstance] {
        return tasks
            .filter({$0.period == period})
            .sorted(by: {$0.time! < $1.time!})
    }
    
    func filterTasksByDay(_ tasks: [TaskInstance]) -> [TaskInstance] {
        let today = Date()
        let todayDayOfTheWeek = Locale.Weekday.from(calendarWeekday: Calendar.current.component(.weekday, from: today))
        
        //filter by task interval
        let intervalTasks = tasks.filter { task in
            guard let start = task.template?.startDate else {
                return false
            }
            
            let end = task.template?.endDate //will be nil if continuous
            let isAfterStart = start <= today
            let isBeforeEnd = end == nil || end! >= today

            return isAfterStart && isBeforeEnd

        }
        for t in intervalTasks {
            print("🚨🚨 INTERVAL TASKS")
            print("Instância: \(t.template!.name ?? "") às \(t.time ?? Date())")
        }
        
        //filter by weekday
        let weekdayTasks = intervalTasks.filter { task in
            
            guard let todayWeek = todayDayOfTheWeek else { return false }
            return task.template?.weekdays.contains(todayWeek) ?? false
        }
        return weekdayTasks
    }
}
