//
//  CareRecipient+Extensions.swift
//  Altroo
//
//  Created by Layza Maria Rodrigues Carneiro on 24/09/25.
//

import CoreData

extension CareRecipient {
    
    convenience init(
        context: NSManagedObjectContext,
        personalData: PersonalData,
        healthProblems: HealthProblems,
        physicalState: PhysicalState,
        mentalState: MentalState,
        personalCare: PersonalCare,
        basicNeeds: BasicNeeds,
        routineActivities: RoutineActivities,
        careRecipientEvents: [CareRecipientEvent],
        symptoms: [Symptom]
    ) {
        self.init(context: context)
        
        self.personalData = personalData
        self.healthProblems = healthProblems
        self.physicalState = physicalState
        self.mentalState = mentalState
        self.personalCare = personalCare
        self.basicNeeds = basicNeeds
        self.routineActivities = routineActivities
        
        careRecipientEvents.forEach { self.addToCareRecipientEvents($0) }
        symptoms.forEach { self.addToSymptoms($0) }
    }
}
