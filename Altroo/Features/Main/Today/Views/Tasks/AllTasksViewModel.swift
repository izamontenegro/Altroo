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
    var period: String
    var frequency: String
    var reminder: Bool
    var time: Date
    var daysOfTheWeek: String
}

class AllTasksViewModel {
    @Published var tasks: [MockTask] = []
//    private let taskService: TaskService
//    
//    init(taskService: TaskService) {
//        self.taskService = taskService
//    }
    
    func loadTasks() {
//        tasks = taskService.fetchAll()
    }
}
