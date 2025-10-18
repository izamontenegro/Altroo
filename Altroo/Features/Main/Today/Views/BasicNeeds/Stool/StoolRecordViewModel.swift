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
    
    @Published var selectedStoolType: StoolTypesEnum? = nil
    @Published var selectedStoolColor: UIColor? = nil
    @Published var selectedCharacteristics: [UrineCharacteristicsEnum] = []
    @Published var urineObservation: String = ""
    
    init(stoolService: BasicNeedsFacade, coreDataService: CoreDataService, userService: UserServiceSession) {
        self.stoolService = stoolService
        self.coreDataService = coreDataService
        self.userService = userService
    }
    
    func createStoolRecord() {
        guard
            let careRecipient = getCurrentCareRecipient()
        else { return }
        
//        urineService.addUrine(
//            period: PeriodEnum.current,
//            date: Date(),
//            color: selectedUrineColor?.hexString ?? "",
//            in: careRecipient,
//            urineCharacteristics: selectedCharacteristics,
//            observation: urineObservation
//        )
        
        checkSavedRecord()
    }
    
    func getNameFromStoolTypes(type: StoolTypesEnum) -> String {
        switch type {
        case .lumpy:
            return "Caroços"
        case .clumpy:
            return "Grumos"
        case .sausageCracks:
            return "Salsicha com Fissuras"
        case .smoothSausage:
            return "Salsicha Lisa"
        case .softPieces:
            return "Pedaços"
        case .mushy:
            return "Pastosa"
        case .watery:
            return "Líquida"
        }
    }
    
    func getImageFromStoolTypes(type: StoolTypesEnum) -> String {
        switch type {
        case .lumpy:
            return "lumpy_stool_illustration"
        case .clumpy:
            return "clumpy_stool_illustration"
        case .sausageCracks:
            return "sausageCracks_stool_illustration"
        case .smoothSausage:
            return "smoothSausage_stool_illustration"
        case .softPieces:
            return "softPieces_stool_illustration"
        case .mushy:
            return "mushy_stool_illustration"
        case .watery:
            return "water_stool_illustration"
        }
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
                print("🚽 [DEBUG] Total stool records found: \(results.count)")
                if let last = results.last {
                    print("🚽 [DEBUG] Last saved stool record:")
                    print("• ID:", last.id?.uuidString ?? "nil")
                    print("• Date:", last.date ?? Date())
                    print("• Period:", last.period ?? "—")
                    print("• Color:", last.color ?? "—")
                    print("• Notes:", last.notes ?? "—")
                    print("• Type:", last.format ?? "—")
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
