//
//  HydrationService.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 29/09/25.
//

import Foundation

protocol HydrationServiceProtocol {
    func addHydrationRecord(period: PeriodEnum, date: Date, waterQuantity: Double, author: String, in careRecipient: CareRecipient)
    
    func deleteHydrationRecord(hydrationRecord: HydrationRecord, from careRecipient: CareRecipient)
}

class HydrationService: HydrationServiceProtocol {
    func addHydrationRecord(period: PeriodEnum, date: Date, waterQuantity: Double, author: String, in careRecipient: CareRecipient)  {
        
        guard let context = careRecipient.managedObjectContext else { return }
        let newHydrationRecord = HydrationRecord(context: context)
        
        newHydrationRecord.date = date
        newHydrationRecord.period = period.rawValue
        newHydrationRecord.waterQuantity = waterQuantity
        newHydrationRecord.author = author
        
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
