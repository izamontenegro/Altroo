//
//  HydrationService.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 29/09/25.
//

import Foundation

protocol HydrationServiceProtocol {
    func addHydrationRecord(period: PeriodEnum, date: Date, behavior: String, waterQuantity: Double, in careRecipient: CareRecipient)
    
    func deleteHydrationRecord(hydrationRecord: HydrationRecord, from careRecipient: CareRecipient)
}

class HydrationService: HydrationServiceProtocol {
    func addHydrationRecord(period: PeriodEnum, date: Date, behavior: String, waterQuantity: Double, in careRecipient: CareRecipient)  {
        let newHydrationRecord = HydrationRecord()
        newHydrationRecord.behavior = behavior
        newHydrationRecord.date = date
        newHydrationRecord.period = period.rawValue
        newHydrationRecord.waterQuantity = waterQuantity
        
        if let basicNeeds = careRecipient.basicNeeds {
            let mutableHydration = basicNeeds.mutableSetValue(forKey: "hydration")
            mutableHydration.add(newHydrationRecord)
        }
    }
    
    func deleteHydrationRecord(hydrationRecord: HydrationRecord, from careRecipient: CareRecipient) {
        if let basicNeeds = careRecipient.basicNeeds {
            let mutableHydration = basicNeeds.mutableSetValue(forKey: "hydration")
            mutableHydration.remove(hydrationRecord)
        }
    }
}
