//
//  HistoryDaySection.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 23/10/25.
//

import Foundation
import Combine
import CoreData
import CloudKit

// MARK: - Section model for UI
struct HistoryDaySection: Identifiable, Equatable {
    let id = UUID()
    let day: Date
    var items: [ReportItem]
    var isExpanded: Bool = true
}

final class HistoryViewModel: ObservableObject {
    
    let userService: UserServiceProtocol
    let careRecipientFacade: CareRecipientFacade
    var basicNeedsFacade: BasicNeedsFacade
    var routineActivitiesFacade: RoutineActivitiesFacade
    
    @Published var sections: [HistoryDaySection] = []
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var errorMessage: String?
    @Published var selectedItem: ReportItem?
    
    //MARK: - RECORDS
    @Published var allRecords: [ReportItem] = []
    
    init(basicNeedsFacade: BasicNeedsFacade, userService: UserServiceProtocol, careRecipientFacade: CareRecipientFacade, routineActivitiesFacade: RoutineActivitiesFacade) {
        self.basicNeedsFacade = basicNeedsFacade
        self.userService = userService
        self.careRecipientFacade = careRecipientFacade
        self.routineActivitiesFacade = routineActivitiesFacade
    }
    // MARK: - Accessors
    func currentCareRecipient() -> CareRecipient? {
        userService.fetchCurrentPatient()
    }
    
    func fetchRecords() {
        guard let currentCareRecipient = currentCareRecipient() else { return }
                
        let hydrationRecords: [ReportItem] = basicNeedsFacade.fetchHydrations(for: currentCareRecipient)
            .map { .hydration($0) }
        
        let feedingRecords: [ReportItem] = basicNeedsFacade.fetchFeedings(for: currentCareRecipient)
            .map { .feeding($0) }

        let stoolRecords: [ReportItem] = basicNeedsFacade.fetchStools(for: currentCareRecipient)
            .map { .stool($0) }

        let urineRecords: [ReportItem] = basicNeedsFacade.fetchUrines(for: currentCareRecipient)
            .map { .urine($0) }
        
        let tasksRecords: [ReportItem] = routineActivitiesFacade.fetchAllInstanceRoutineTasks(from: currentCareRecipient)
            .filter { $0.isDone }
            .map { .task($0) }

        let symptomRecords: [ReportItem] = careRecipientFacade.fetchAllSymptoms(from: currentCareRecipient)
            .map { .symptom($0) }
        
        allRecords = hydrationRecords + feedingRecords + stoolRecords + urineRecords + tasksRecords + symptomRecords
    }
    
    func reloadHistory(limit: Int? = nil) {
        guard let recipient = currentCareRecipient() else {
            sections = []
            return
        }
        isLoading = true
        errorMessage = nil
        
        fetchRecords()
        
        sections = Self.buildSections(from: allRecords)
        if sections.indices.count > 1 {
            for idx in sections.indices.dropFirst() { sections[idx].isExpanded = false }
        }
        isLoading = false
    }
    
    func deleteHistory(_ item: ReportItem) {
        deleteItem(item)
        reloadHistory()
    }
    
    static func buildSections(from items: [ReportItem]) -> [HistoryDaySection] {
        let cal = Calendar.current
        let grouped = Dictionary(grouping: items) { item -> Date in
            let base = item.base.reportTime ?? Date.distantPast
            let comps = cal.dateComponents([.year, .month, .day], from: base)
            return cal.date(from: comps) ?? base
        }
        
        return grouped
            .map { (day, bucket) in
                HistoryDaySection(
                    day: day,
                    items: bucket.sorted(by: { ($0.base.reportTime ?? .distantPast) > ($1.base.reportTime ?? .distantPast) }),
                    isExpanded: true
                )
            }
            .sorted(by: { $0.day > $1.day })
    }
    
    func deleteItem(_ item: ReportItem) {
        guard let recipient = currentCareRecipient() else { return }

        switch item {
        case .stool(let stoolRecord):
            basicNeedsFacade.deleteStool(stoolRecord: stoolRecord, from: recipient)
        case .urine(let urineRecord):
            basicNeedsFacade.deleteUrine(urineRecord: urineRecord, from: recipient)
        case .feeding(let feedingRecord):
            basicNeedsFacade.deleteFeeding(feedingRecord: feedingRecord, from: recipient)
        case .hydration(let hydrationRecord):
            basicNeedsFacade.deleteHydration(hydrationRecord: hydrationRecord, from: recipient)
        case .task(let taskInstance):
            routineActivitiesFacade.deleteInstanceRoutineTask(taskInstance)
        case .symptom(let symptom):
            careRecipientFacade.deleteSymptom(symptomRecord: symptom, from: recipient)
        }
    }
}
