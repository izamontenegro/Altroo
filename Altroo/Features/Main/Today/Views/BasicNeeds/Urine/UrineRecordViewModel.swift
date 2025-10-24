//
//  UrineRecordViewModel.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 16/10/25.
//

import Foundation
import UIKit
import Combine
import CoreData

final class UrineRecordViewModel {
    let urineService: BasicNeedsFacade
    let userService: UserServiceSession
    let coreDataService: CoreDataService
    
    @Published var selectedUrineColor: UIColor? = nil
    @Published var selectedCharacteristics: [UrineCharacteristicsEnum] = []
    @Published var urineObservation: String = ""
    
    init(urineService: BasicNeedsFacade, coreDataService: CoreDataService, userService: UserServiceSession) {
        self.urineService = urineService
        self.coreDataService = coreDataService
        self.userService = userService
    }
    
    func createUrineRecord() {
        guard
            let careRecipient = getCurrentCareRecipient()
        else { return }
        
        urineService.addUrine(
            period: PeriodEnum.current,
            date: Date(),
            color: selectedUrineColor?.hexString ?? "",
            in: careRecipient,
            urineCharacteristics: selectedCharacteristics,
            observation: urineObservation
        )
        
        checkSavedRecord()
    }
    
    // MARK: - PRIVATE FUNCTIONS
    
    private func checkSavedRecord() {
    // MARK: - 🔍 Debug: verify that the record was actually saved in Core Data
    // This block fetches all urine records from the context and prints the last one.
    // It’s only for debugging until we have a proper UI (history) to display the data.
        
        guard
            let careRecipient = getCurrentCareRecipient()
        else { return }
        
        if let context = careRecipient.managedObjectContext {
            let request: NSFetchRequest<UrineRecord> = UrineRecord.fetchRequest()
            do {
                let results = try context.fetch(request)
//                print("💧 [DEBUG] Total urine records found: \(results.count)")
                if let last = results.last {
//                    print("💧 [DEBUG] Last saved urine record:")
//                    print("• ID:", last.id?.uuidString ?? "nil")
//                    print("• Date:", last.date ?? Date())
//                    print("• Period:", last.period ?? "—")
//                    print("• Color:", last.color ?? "—")
//                    print("• Characteristics:", last.urineCharacteristics ?? "—")
//                    print("• Observation:", last.urineObservation ?? "—")
                }
            } catch {
                print("⚠️ [DEBUG] Failed to fetch UrineRecord:", error.localizedDescription)
            }
        } else {
            print("⚠️ [DEBUG] No managedObjectContext found for the current CareRecipient.")
        }
    }
    
    private func getCurrentCareRecipient() -> CareRecipient? {
        userService.fetchCurrentPatient()
    }
}
