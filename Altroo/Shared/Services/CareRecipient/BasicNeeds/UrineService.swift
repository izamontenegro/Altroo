//
//  UrineService.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 29/09/25.
//

import Foundation

protocol UrineServiceProtocol {
    func addUrineRecord(period: PeriodEnum, date: Date, hadPain: Bool, color: String, in careRecipient: CareRecipient)
    
    func deleteUrineRecord(urineRecord: UrineRecord, from careRecipient: CareRecipient)
}

class UrineService: UrineServiceProtocol {
    func addUrineRecord(period: PeriodEnum, date: Date, hadPain: Bool, color: String, in careRecipient: CareRecipient) {
        
        guard let context = careRecipient.managedObjectContext else { return }
        let newUrineRecord = UrineRecord(context: context)
        
        newUrineRecord.color = color
        newUrineRecord.date = date
        newUrineRecord.pain = hadPain
        newUrineRecord.period = period.rawValue
        
        if let basicNeeds = careRecipient.basicNeeds {
            let mutableUrine = basicNeeds.mutableSetValue(forKey: "urine")
            mutableUrine.add(newUrineRecord)
        }
    }
    
    func deleteUrineRecord(urineRecord: UrineRecord, from careRecipient: CareRecipient) {
        if let basicNeeds = careRecipient.basicNeeds {
            let mutableUrine = basicNeeds.mutableSetValue(forKey: "urine")
            mutableUrine.remove(urineRecord)
        }
    }
}
