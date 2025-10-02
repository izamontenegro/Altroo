//
//  AppFactory.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 22/09/25.
//

import UIKit

protocol AppFactory:
    OnboardingFactory,
    AssociatePatientFactory,
    MainFlowFactory,
    AddItemFactory,
    TodayFactory,
    ProfileFactory,
    EventsFactory,
    MedicationFactory,
    BasicNeedsFactory,
    RoutineActivitiesFactory,
    MeasurementFactory,
    GeneralFactory,
    HistoryFactory,
    SettingsFactory {
}

// MARK: - ONBOARDING FLOW
protocol OnboardingFactory {
    func makeWelcomeViewController(delegate: WelcomeViewControllerDelegate) -> UIViewController
}

// MARK: - ALL PATIENT FLOW
protocol AssociatePatientFactory {
    func makeAssociatePatientViewController(delegate: AssociatePatientViewControllerDelegate) -> UIViewController
    func makeTutorialAddSheet() -> UIViewController
    func makePatientFormViewController(delegate: AssociatePatientViewControllerDelegate) -> UIViewController
    func makeComorbiditiesFormViewController(delegate: AssociatePatientViewControllerDelegate) -> UIViewController
    func makeShiftFormViewController(delegate: ShiftFormsViewControllerDelegate) -> UIViewController
}

// MARK: - MAIN FLOW
protocol MainFlowFactory {
    func makeSettingsViewController(delegate: SettingsViewControllerDelegate) -> UIViewController
    func makeTodayViewController(delegate: TodayViewControllerDelegate) -> UIViewController
    func makeHistoryViewController(delegate: HistoryViewControllerDelegate) -> UIViewController
    func makeAnalysisViewController() -> UIViewController
}

// MARK: - ADD ITEM FLOW
protocol AddItemFactory {
    func makeAddItemSheet(delegate: AddItemsSheetViewControllerDelegate) -> UIViewController
}

// MARK: - TODAY FLOW
protocol TodayFactory {
    func makeEditSectionsViewController() -> UIViewController
    func makeAddSymptomViewController() -> UIViewController
}

// MARK: - PROFILE FLOW
protocol ProfileFactory {
    func makeProfileViewController(delegate: ProfileViewControllerDelegate) -> UIViewController
    func makeChangeCaregiverViewController() -> UIViewController
    func makeEditCaregiverViewController() -> UIViewController
}

// MARK: - EVENTS FLOW
protocol EventsFactory {
    func makeAllEventsViewController() -> UIViewController
    func makeEventDetailSheet() -> UIViewController
    func makeAddEventViewController() -> UIViewController
}

// MARK: - MEDICATION FLOW
protocol MedicationFactory {
    func makeMedicationDetailSheet() -> UIViewController
    func makeAllMedicationViewController() -> UIViewController
    func makeAddMedicationViewController() -> UIViewController
    func makeMedicationTimeSheet() -> UIViewController
}

// MARK: - ADD BASIC NEEDS FLOW
protocol BasicNeedsFactory {
    func makeStoolRecordViewController() -> UIViewController
    func makeUrineRecordViewController() -> UIViewController
    func makeMealRecordViewController() -> UIViewController
    func makeHydrationRecordSheet() -> UIViewController
}

// MARK: - ROUTINE ACTIVITIES FLOW
protocol RoutineActivitiesFactory {
    func makeAllTasksViewController() -> UIViewController
    func makeAddTaskViewController() -> UIViewController
}

// MARK: - MEASUREMENT FLOW
protocol MeasurementFactory {
    func makeRecordHeartRateSheet() -> UIViewController
    func makerRecordGlycemiaSheet() -> UIViewController
    func makeRecordBloodPressureSheet() -> UIViewController
    func makeRecordTemperatureSheet() -> UIViewController
    func makeRecordSaturationSheet() -> UIViewController
}

// MARK: - GENERAL FLOW
protocol GeneralFactory {
    func makeAddIntervalSheet() -> UIViewController
}

// MARK: - HISTORY FLOW
protocol HistoryFactory {
    func makeSeeHistoryDetailSheet() -> UIViewController
}

// MARK: - SETTINGS FLOW
protocol SettingsFactory {
    func makeUserProfileViewController() -> UIViewController
    func makePrivacySecurityViewController() -> UIViewController
    func makeDevelopersViewController() -> UIViewController
}
