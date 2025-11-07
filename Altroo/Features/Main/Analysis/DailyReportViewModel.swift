//
//  DailyReportViewModel.swift
//  Altroo
//
//  Created by Raissa Parente on 05/11/25.
//

import Foundation

struct CategoryInfo {
    let name: String
    let icon: String
    let reports: [ReportItem]
}


class DailyReportViewModel: ObservableObject {
    //MARK: - DEPENDENCIES
    let userService: UserServiceProtocol
    let careRecipientFacade: CareRecipientFacade
    var basicNeedsFacade: BasicNeedsFacade
    var routineActivitiesFacade: RoutineActivitiesFacade
    
    //MARK: - RECORDS
    @Published var hydrationRecords: [ReportItem] = []
    @Published var feedingRecords: [ReportItem] = []
    @Published var stoolRecords: [ReportItem] = []
    @Published var urineRecords: [ReportItem] = []
    @Published var tasksRecords: [ReportItem] = []
    @Published var symptomRecords: [ReportItem] = []
    
    var nonEmptyCategories: [CategoryInfo] {
           [
               CategoryInfo(name: "Urina", icon: "drop.halffull", reports: urineRecords),
               CategoryInfo(name: "Alimentação", icon: "takeoutbag.and.cup.and.straw.fill", reports: feedingRecords),
               CategoryInfo(name: "Hidratação", icon: "waterbottle.fill", reports: hydrationRecords),
               CategoryInfo(name: "Intercorrência", icon: "exclamationmark.triangle.fill", reports: symptomRecords),
               CategoryInfo(name: "Tarefas", icon: "newspaper", reports: tasksRecords)
           ]
           .filter { !$0.reports.isEmpty }
       }
    
    //MARK: - FILTERS
    @Published var startDate: Date = Date()
    @Published var endDate: Date?
    @Published var startTime: Date = Calendar.current.startOfDay(for: .now)
    @Published var endTime: Date = {
        let startOfTomorrow = Calendar.current.startOfDay(for: Calendar.current.date(byAdding: .day, value: 1, to: .now)!)
        return startOfTomorrow.addingTimeInterval(-1)
    }()
    
    var timeRange: ClosedRange<Date> {
        guard let fullStart = combine(date: startDate, withTimeFrom: startTime) else {
            return Date.now...Date.now
        }

        // periodical report
        if let endDate,
           let fullEnd = combine(date: endDate, withTimeFrom: endTime) {
            return fullStart...fullEnd
        } else {
            //daily report -> has no endday, but may have endtime
            guard let fallbackEnd = combine(date: startDate, withTimeFrom: endTime) else {
                return fullStart...fullStart
            }
            return fullStart...fallbackEnd
        }
                
    }

    init(basicNeedsFacade: BasicNeedsFacade, userService: UserServiceProtocol, careRecipientFacade: CareRecipientFacade, routineActivitiesFacade: RoutineActivitiesFacade) {
        self.basicNeedsFacade = basicNeedsFacade
        self.userService = userService
        self.careRecipientFacade = careRecipientFacade
        self.routineActivitiesFacade = routineActivitiesFacade
        
        feedArrays()
    }
    
    var currentCareRecipient: CareRecipient? {
        return userService.fetchCurrentPatient()
    }
    
    func feedArrays() {
        guard let currentCareRecipient else { return }
                
        hydrationRecords = basicNeedsFacade.fetchHydrations(for: currentCareRecipient)
            .filter { timeRange.contains($0.reportTime ?? .now)}
            .map { .hydration($0) }
        
        feedingRecords = basicNeedsFacade.fetchFeedings(for: currentCareRecipient)
            .filter { timeRange.contains($0.reportTime ?? .now)}
            .map { .feeding($0) }

        stoolRecords = basicNeedsFacade.fetchStools(for: currentCareRecipient)
            .filter { timeRange.contains($0.reportTime ?? .now)}
            .map { .stool($0) }

        urineRecords = basicNeedsFacade.fetchUrines(for: currentCareRecipient)
            .filter { timeRange.contains($0.reportTime ?? .now)}
            .map { .urine($0) }
        
        tasksRecords = routineActivitiesFacade.fetchAllInstanceRoutineTasks(from: currentCareRecipient)
            .filter { $0.isDone }
            .filter { timeRange.contains($0.reportTime ?? .now)}
            .map { .task($0) }

        symptomRecords = careRecipientFacade.fetchAllSymptoms(from: currentCareRecipient)
            .filter { timeRange.contains($0.reportTime ?? .now)}
            .map { .symptom($0) }
    }
    
    //MARK: - COUNTING
    var combinedRecords: [ReportItem] {
        hydrationRecords + feedingRecords + stoolRecords + urineRecords + tasksRecords + symptomRecords
    }
    
    //MARK: - UTIL
    func combine(date datePart: Date, withTimeFrom timePart: Date, using calendar: Calendar = .current) -> Date? {
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: datePart)
        let timeComponents = calendar.dateComponents([.hour, .minute, .second], from: timePart)
        
        var combined = DateComponents()
        combined.year = dateComponents.year
        combined.month = dateComponents.month
        combined.day = dateComponents.day
        combined.hour = timeComponents.hour
        combined.minute = timeComponents.minute
        combined.second = timeComponents.second
        
        return calendar.date(from: combined)
    }
}
