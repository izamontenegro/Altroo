//
//  AppDependencies.swift
//  Altroo
//
//  Created by Raissa Parente on 10/10/25.
//

final class AppDependencies {
    let coreDataService: CoreDataService
    let basicNeedsFacade: BasicNeedsFacade
    let routineActivitiesFacade: RoutineActivitiesFacade
    let careRecipientFacade: CareRecipientFacade
    let userService: UserServiceSession

    init() {
        self.coreDataService = CoreDataService()

        self.basicNeedsFacade = BasicNeedsFacade(
            feedingService: FeedingService(),
            hydrationService: HydrationService(),
            stoolService: StoolService(),
            urineService: UrineService(),
            persistenceService: coreDataService
        )
        
        self.routineActivitiesFacade = RoutineActivitiesFacade(
            routineTaskService: RoutineTaskService(),
            medicationService: MedicationService(),
            measurementService: MeasurementService(),
            persistenceService: coreDataService)

        self.careRecipientFacade = CareRecipientFacade(
            basicNeedsFacade: basicNeedsFacade,
            routineActivitiesFacade: routineActivitiesFacade,
            persistenceService: coreDataService
        )
        
        self.userService = UserServiceSession(context: coreDataService.stack.context)
    }
}

