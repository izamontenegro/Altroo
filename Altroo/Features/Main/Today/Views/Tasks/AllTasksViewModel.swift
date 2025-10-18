//
//  AllTasksViewModel.swift
//  Altroo
//
//  Created by Raissa Parente on 07/10/25.
//
import Foundation
import Combine

class AllTasksViewModel {
    var taskService: RoutineActivitiesFacadeProtocol
    var currentCareRecipient: CareRecipient
    
    @Published var tasks: [TaskInstance] = []
  
    init(taskService: RoutineActivitiesFacadeProtocol,
         currentCareRecipient: CareRecipient) {
        self.currentCareRecipient = currentCareRecipient
        self.taskService = taskService
        loadTasks()
    }
    
    func loadTasks() {
        taskService.generateInstancesForToday(for: currentCareRecipient)
        let allTasks = taskService.fetchAllInstanceRoutineTasks(from: currentCareRecipient)
        tasks = filterTasksByDay(allTasks)
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
        
        //filter by weekday
        let weekdayTasks = intervalTasks.filter { task in
            
            guard let todayWeek = todayDayOfTheWeek else { return false }
            return task.template?.weekdays.contains(todayWeek) ?? false
        }
        return weekdayTasks
    }
    
    func markAsDone(_ instance: TaskInstance) {
        taskService.markInstanceAsDone(instance)
    }
}
