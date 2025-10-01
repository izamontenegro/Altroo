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
    ProfileFactory,
    EventsFactory,
    MedicationFactory,
    BasicNeedsFactory,
    RoutineActivitiesFactory,
    MeasurementFactory,
    GeneralFactory,
    HistoryFactory {
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
    func makeSettingsViewController() -> UIViewController
    func makeTodayViewController(delegate: TodayViewControllerDelegate) -> UIViewController
    func makeHistoryViewController() -> UIViewController
    func makeAnalysisViewController() -> UIViewController
}

// MARK: - ADD ITEM FLOW
protocol AddItemFactory {
    func makeAddItemSheet(delegate: AddItemsSheetViewControllerDelegate) -> UIViewController
    func makeAddBasicNeedsSheet() -> UIViewController
    func makeAddMeasurementSheet() -> UIViewController
    func makeAddMedicationViewController() -> UIViewController
    func makeAddRoutineActivityViewController() -> UIViewController
    func makeAddSymptomViewController() -> UIViewController
    func makeAddEventViewController() -> UIViewController
}

// MARK: - PROFILE FLOW
protocol ProfileFactory {
    func makeProfileViewController() -> UIViewController
}

// MARK: - EVENTS FLOW
protocol EventsFactory {
    func makeAllEventsViewController() -> UIViewController
    func makeEventDetailSheet() -> UIViewController
}

// MARK: - MEDICATION FLOW
protocol MedicationFactory {
    func makeMedicationDetailSheet() -> UIViewController
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
    func makeAllRoutineActivitiesViewController() -> UIViewController
}

// MARK: - MEASUREMENT FLOW
protocol MeasurementFactory {
    func makeRecordMeasurementSheet() -> UIViewController
}

// MARK: - GENERAL FLOW
protocol GeneralFactory {
    func makeAddIntervalSheet() -> UIViewController
}

// MARK: - HISTORY FLOW
protocol HistoryFactory {
    func makeSeeHistoryDetailSheet() -> UIViewController
}

protocol SettingsFactory {
    // TODO: - SETTINGS FLOW
}
