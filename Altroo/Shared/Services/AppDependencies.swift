//
//  AppDependencies.swift
//  Altroo
//
//  Created by Raissa Parente on 10/10/25.
//

final class AppDependencies {
    let coreDataService: CoreDataService
    let basicNeedsFacade: BasicNeedsFacade
    let careRecipientFacade: CareRecipientFacade

    init() {
        self.coreDataService = CoreDataService()

        self.basicNeedsFacade = BasicNeedsFacade(
            feedingService: FeedingService(),
            hydrationService: HydrationService(),
            stoolService: StoolService(),
            urineService: UrineService(),
            persistenceService: coreDataService
        )

        self.careRecipientFacade = CareRecipientFacade(
            basicNeedsFacade: basicNeedsFacade,
            persistenceService: coreDataService
        )
    }
}
