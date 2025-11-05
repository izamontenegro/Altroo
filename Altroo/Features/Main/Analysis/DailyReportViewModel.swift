//
//  DailyReportViewModel.swift
//  Altroo
//
//  Created by Raissa Parente on 05/11/25.
//

import Foundation

class DailyReportViewModel: ObservableObject {
    
    let userService: UserServiceProtocol
    let careRecipientFacade: CareRecipientFacade
    var basicNeedsFacade: BasicNeedsFacade
    var routineActivitiesFacade: RoutineActivitiesFacade
    
    var hydrationRecords: [ReportItem] = []
    var feedingRecords: [ReportItem] = []
    var stoolRecords: [ReportItem] = []
    var urineRecords: [ReportItem] = []
    
    var tasksRecords: [ReportItem] = []
    var symptomRecords: [ReportItem] = []

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
            .map { .hydration($0) }
        feedingRecords = basicNeedsFacade.fetchFeedings(for: currentCareRecipient)
            .map { .feeding($0) }

        stoolRecords = basicNeedsFacade.fetchStools(for: currentCareRecipient)
            .map { .stool($0) }

        urineRecords = basicNeedsFacade.fetchUrines(for: currentCareRecipient)
            .map { .urine($0) }
        
        tasksRecords = routineActivitiesFacade.fetchAllInstanceRoutineTasks(from: currentCareRecipient)
            .filter { $0.isDone }
            .map { .task($0) }

        symptomRecords = careRecipientFacade.fetchAllSymptoms(from: currentCareRecipient)            .map { .symptom($0) }
        
        
        print("Agua: \(hydrationRecords)")
        print("Xixi: \(urineRecords)")
        print("Coco: \(stoolRecords)")
        print("Sintomas: \(symptomRecords)")
        print("Gagau: \(tasksRecords)")

    }
    
    
}
