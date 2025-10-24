//
//  CareRecipientFacade.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 29/09/25.
//

import Foundation
import CoreData

protocol BasicNeedsFacadeProtocol {}

protocol RoutineActivitiesFacadeProtocol {}

class CareRecipientFacade {
    let persistenceService: CoreDataService
    let basicNeedsFacade: BasicNeedsFacadeProtocol
    let routineActivitiesFacade: RoutineActivitiesFacadeProtocol
        
    init(basicNeedsFacade: BasicNeedsFacadeProtocol,
         routineActivitiesFacade: RoutineActivitiesFacadeProtocol,
         persistenceService: CoreDataService) {
        self.basicNeedsFacade = basicNeedsFacade
        self.routineActivitiesFacade = routineActivitiesFacade
        self.persistenceService = persistenceService
    }
}

extension CareRecipientFacade {
    
    func buildCareRecipient(
        configure: (PersonalData, PersonalCare, HealthProblems, MentalState, PhysicalState, RoutineActivities, BasicNeeds, CareRecipientEvent, Symptom) -> Void
    ) -> CareRecipient {
        let context = persistenceService.stack.context
        
        let careRecipient = CareRecipient(context: context)
        let personalData = PersonalData(context: context)
        let personalCare = PersonalCare(context: context)
        let mentalState = MentalState(context: context)
        let physicalState = PhysicalState(context: context)
        let healthProblems = HealthProblems(context: context)
        let routineActivities = RoutineActivities(context: context)
        let basicNeeds = BasicNeeds(context: context)
        let careRecipientEvent = CareRecipientEvent(context: context)
        let symptom = Symptom(context: context)
        
        careRecipient.personalData = personalData
        careRecipient.personalCare = personalCare
        careRecipient.healthProblems = healthProblems
        careRecipient.mentalState = mentalState
        careRecipient.physicalState = physicalState
        careRecipient.routineActivities = routineActivities
        careRecipient.basicNeeds = basicNeeds
        careRecipient.careRecipientEvents = [careRecipientEvent]
        careRecipient.symptoms = [symptom]
        careRecipient.waterTarget = 2000.0
        careRecipient.waterMeasure = 250.0
        careRecipient.id = UUID()
        
        configure(personalData, personalCare, healthProblems, mentalState, physicalState, routineActivities, basicNeeds, careRecipientEvent, symptom)
        
        persistenceService.save()
        
        return careRecipient
    }
    
    func fetchCareRecipient(by id: UUID) -> CareRecipient? {
        return persistenceService.fetchAllCareRecipients().first(where: { $0.id == id })
    }
    
    func fetchAllCareRecipients() -> [CareRecipient] {
        let request: NSFetchRequest<CareRecipient> = CareRecipient.fetchRequest()
        do {
            return try persistenceService.stack.context.fetch(request)
        } catch {
            print("Error searching for patients:", error)
            return []
        }
    }
    
    func deleteCareRecipient(_ careRecipient: CareRecipient) {
        persistenceService.deleteCareRecipient(careRecipient)
    }
    
    func setWaterTarget(_ waterTarget: Double, _ careRecipient: CareRecipient) {
        careRecipient.waterTarget = waterTarget
        persistenceService.save()
    }
    
    func setWaterMeasure(_ waterMeasure: Double, _ careRecipient: CareRecipient) {
        careRecipient.waterMeasure = waterMeasure
        persistenceService.save()
    }
    
    func getWaterTarget(_ careRecipient: CareRecipient) -> Double {
        return careRecipient.waterTarget
    }
    
    func getWaterMeasure(_ careRecipient: CareRecipient) -> Double {
        return careRecipient.waterMeasure
    }
}
