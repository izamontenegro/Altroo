//
//  CareRecipientFacade.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 29/09/25.
//

import Foundation
import CoreData

protocol BasicNeedsFacadeProtocol {}

protocol RoutineActivitiesFacadeProtocol {
//    func fetchAllTemplateRoutineTasks(from careRecipient: CareRecipient) -> [RoutineTask]
//       func addTemplateRoutineTask(
//           name: String,
//           allTimes: [DateComponents],
//           daysOfTheWeek: [Locale.Weekday],
//           startDate: Date,
//           endDate: Date?,
//           reminder: Bool,
//           note: String,
//           in careRecipient: CareRecipient
//       )
//       func deleteRoutineTask(routineTask: RoutineTask, from careRecipient: CareRecipient)
       
       func fetchAllInstanceRoutineTasks(from careRecipient: CareRecipient) -> [TaskInstance]
//       func addInstanceRoutineTask(from template: RoutineTask, on date: Date)
       func markInstanceAsDone(_ instance: TaskInstance)
//       func deleteInstanceRoutineTask(_ instance: TaskInstance)
       
       func generateInstancesForToday(for careRecipient: CareRecipient)
}

extension RoutineActivitiesFacadeProtocol {
    func fetchAllInstanceRoutineTasks(from careRecipient: CareRecipient) -> [TaskInstance] { return [] }
    func generateInstancesForToday(for careRecipient: CareRecipient) {}
    func markInstanceAsDone(_ instance: TaskInstance) {}

}

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

}
