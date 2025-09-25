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
        events: [CareRecipientEvents],
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
        
        events.forEach { self.addToEvents($0) }
        symptoms.forEach { self.addToSymptoms($0) }
    }
}
