//
//  CareRecipient+Event.swift
//  Altroo
//
//  Created by Layza Maria Rodrigues Carneiro on 06/10/25.
//

import Foundation

protocol EventProtocol {
    func addEvent(name: String, category: String, startDate: Date, endDate: Date, startTime: Date, endTime: Date, location: String, note: String, in careRecipient: CareRecipient)
    func deleteEvent(eventRecord: CareRecipientEvent, from careRecipient: CareRecipient)
}

extension CareRecipientFacade: EventProtocol {
    
    func addEvent(name: String, category: String, startDate: Date, endDate: Date, startTime: Date, endTime: Date, location: String, note: String, in careRecipient: CareRecipient) {
        
        guard let context = careRecipient.managedObjectContext else { return }
        
        let newEvent = CareRecipientEvent(context: context)
        newEvent.name = name
        newEvent.category = category
        newEvent.startDate = startDate
        newEvent.endDate = endDate
        newEvent.startTime = startTime
        newEvent.endTime = endTime
        newEvent.location = location
        newEvent.note = note
        
        let eventsSet = careRecipient.mutableSetValue(forKey: "events")
        eventsSet.add(newEvent)
    }
    
    func deleteEvent(eventRecord: CareRecipientEvent, from careRecipient: CareRecipient) {
        let eventsSet = careRecipient.mutableSetValue(forKey: "events")
        eventsSet.remove(eventRecord)
    }

}
