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
    func makeWelcome(delegate: WelcomeViewControllerDelegate) -> UIViewController
}

// MARK: - ALL PATIENT FLOW
protocol AssociatePatientFactory {
    func makeAssociatePatient(delegate: AssociatePatientViewControllerDelegate) -> UIViewController
    func makeTutorialAddSheet() -> UIViewController
    func makePatientForm(delegate: AssociatePatientViewControllerDelegate) -> UIViewController
    func makeComorbiditiesForms(delegate: AssociatePatientViewControllerDelegate) -> UIViewController
    func makeShiftForms(delegate: ShiftFormsViewControllerDelegate) -> UIViewController
}

// MARK: - MAIN FLOW
protocol MainFlowFactory {
    func makeSettings() -> UIViewController
    func makeToday(delegate: TodayViewControllerDelegate) -> UIViewController
    func makeHistory() -> UIViewController
    func makeAnalysis() -> UIViewController
}

// MARK: - ADD ITEM FLOW
protocol AddItemFactory {
    func makeAddItemSheet(delegate: AddItemsSheetViewControllerDelegate) -> UIViewController
    func makeAddBasicNeedsSheet() -> UIViewController
    func makeAddMeasurementSheet() -> UIViewController
    func makeAddMedication() -> UIViewController
    func makeAddRoutineActivity() -> UIViewController
    func makeAddSymptom() -> UIViewController
    func makeAddEvent() -> UIViewController
}

// MARK: - PROFILE FLOW
protocol ProfileFactory {
    func makeProfile() -> UIViewController
}

// MARK: - EVENTS FLOW
protocol EventsFactory {
    func makeSeeAllEvents() -> UIViewController
    func makeEventDetailSheet() -> UIViewController
}

// MARK: - MEDICATION FLOW
protocol MedicationFactory {
    func makeMedicationDetailSheet() -> UIViewController
    func makeMedicationTimeSheet() -> UIViewController
}

// MARK: - ADD BASIC NEEDS FLOW
protocol BasicNeedsFactory {
    func makeStoolRecord() -> UIViewController
    func makeUrineRecord() -> UIViewController
    func makeMealRecord() -> UIViewController
    func makeHydrationRecordSheet() -> UIViewController
}

// MARK: - ROUTINE ACTIVITIES FLOW
protocol RoutineActivitiesFactory {
    func makeSeeAllRoutineActivities() -> UIViewController
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
