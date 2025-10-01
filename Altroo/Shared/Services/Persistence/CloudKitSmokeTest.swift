//
//  CloudKitSmokeTest.swift
//  Altroo
//
//  Created by Raissa Parente on 25/09/25.
//

import Foundation
import CoreData

func smokeTestCloudKit() {
    let stack = CoreDataStack.shared
    let service = CoreDataService(stack: stack)
    
    let personalData = PersonalData(context: stack.context)
    personalData.name = "Mrs. Olivetree"
    let recipient = CareRecipient(context: stack.context)
    recipient.personalData = personalData
    
    service.save()
}
