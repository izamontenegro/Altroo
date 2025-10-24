//
//  StoolRecordViewModel.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 18/10/25.
//

import Foundation
import UIKit
import Combine
import CoreData

final class StoolRecordViewModel {
    let stoolService: BasicNeedsFacade
    let userService: UserServiceSession
    let coreDataService: CoreDataService
    private let historyService: HistoryService

    
    @Published var selectedStoolType: StoolTypesEnum? = nil
    @Published var selectedStoolColor: UIColor? = nil
    @Published var selectedCharacteristics: [UrineCharacteristicsEnum] = []
    @Published var notes: String = ""
    
    init(stoolService: BasicNeedsFacade, coreDataService: CoreDataService, userService: UserServiceSession, historyService: HistoryService) {
        self.stoolService = stoolService
        self.coreDataService = coreDataService
        self.userService = userService
        self.historyService = historyService
    }
    
    func createStoolRecord() {
        
        guard
            let careRecipient = getCurrentCareRecipient()
        else { return }
        
        stoolService.addStool(period: PeriodEnum.current, date: Date(), format: selectedStoolType?.rawValue ?? "", notes: notes, color: selectedStoolColor?.hexString ?? "", in: careRecipient)
        
        let author = coreDataService.currentPerformerName(for: careRecipient)
       
        historyService.addHistoryItem(title: "Bebeu ml de água", author: author, date: Date(), to: careRecipient)
        
        checkSavedRecord()
    }
    
    // MARK: - PRIVATE FUNCTIONS
    private func checkSavedRecord() {
    // MARK: - 🔍 Debug: verify that the record was actually saved in Core Data
    // This block fetches all stool records from the context and prints the last one.
    // It’s only for debugging until we have a proper UI (history) to display the data.
        
        guard
            let careRecipient = getCurrentCareRecipient()
        else { return }
        
        if let context = careRecipient.managedObjectContext {
            let request: NSFetchRequest<StoolRecord> = StoolRecord.fetchRequest()
            do {
                let results = try context.fetch(request)
//                print("🚽 [DEBUG] Total stool records found: \(results.count)")
                if let last = results.last {
//                    print("🚽 [DEBUG] Last saved stool record:")
//                    print("• ID:", last.id?.uuidString ?? "nil")
//                    print("• Date:", last.date ?? Date())
//                    print("• Period:", last.period ?? "—")
//                    print("• Color:", last.color ?? "—")
//                    print("• Notes:", last.notes ?? "—")
//                    print("• Type:", last.format ?? "—")
                }
            } catch {
                print("⚠️ [DEBUG] Failed to fetch StoolRecord:", error.localizedDescription)
            }
        } else {
            print("⚠️ [DEBUG] No managedObjectContext found for the current CareRecipient.")
        }
    }
    
    private func getCurrentCareRecipient() -> CareRecipient? {
        userService.fetchCurrentPatient()
    }
}
