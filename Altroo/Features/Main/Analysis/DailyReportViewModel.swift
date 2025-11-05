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
    
    var hydrationRecords: [HydrationRecord] = []
    var feedingRecords: [FeedingRecord] = []
    var stoolRecords: [StoolRecord] = []
    var urineRecords: [UrineRecord] = []
    
    var tasksRecords: [TaskInstance] = []
    var symptomRecords: [Symptom] = []


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
        feedingRecords = basicNeedsFacade.fetchFeedings(for: currentCareRecipient)
        stoolRecords = basicNeedsFacade.fetchStools(for: currentCareRecipient)
        urineRecords = basicNeedsFacade.fetchUrines(for: currentCareRecipient)
        
        tasksRecords = routineActivitiesFacade.fetchAllInstanceRoutineTasks(from: currentCareRecipient)
            .filter({$0.isDone})
        symptomRecords = careRecipientFacade.fetchAllSymptoms(from: currentCareRecipient)
    }
    
    
}
