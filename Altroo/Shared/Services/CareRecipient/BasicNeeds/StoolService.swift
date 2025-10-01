//
//  StoolService.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 29/09/25.
//

import Foundation

protocol StoolServiceProtocol {
    func addStoolRecord(period: PeriodEnum, date: Date, format: String, hadPain: Bool, color: String, in careRecipient: CareRecipient)
    
    func deleteStoolRecord(stoolRecord: StoolRecord, from careRecipient: CareRecipient)
}

class StoolService: StoolServiceProtocol {
    func addStoolRecord(period: PeriodEnum, date: Date, format: String, hadPain: Bool, color: String, in careRecipient: CareRecipient) {
        
        guard let context = careRecipient.managedObjectContext else { return }
        let newStoolRecord = StoolRecord(context: context)
        
        newStoolRecord.color = color
        newStoolRecord.date = date
        newStoolRecord.format = format
        newStoolRecord.pain = hadPain
        newStoolRecord.period = period.rawValue
        
        if let basicNeeds = careRecipient.basicNeeds {
            let mutableStool = basicNeeds.mutableSetValue(forKey: "stool")
            mutableStool.add(newStoolRecord)
        }
    }
    
    func deleteStoolRecord(stoolRecord: StoolRecord, from careRecipient: CareRecipient) {
        if let basicNeeds = careRecipient.basicNeeds {
            let mutableStool = basicNeeds.mutableSetValue(forKey: "stool")
            mutableStool.remove(stoolRecord)
        }
    }
    
}
