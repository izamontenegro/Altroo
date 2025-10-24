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
    TodayFactory,
    ProfileFactory,
    EventsFactory,
    MedicationFactory,
    BasicNeedsFactory,
    RoutineActivitiesFactory,
    MeasurementFactory,
    SymptomFactory,
    GeneralFactory,
    HistoryFactory,
    SettingsFactory,
    ServiceFactory {
}

// MARK: - ONBOARDING FLOW
protocol OnboardingFactory {
    func makeWelcomeOnboardingViewController(delegate: WelcomeOnboardingViewControllerDelegate) -> UIViewController
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

// MARK: - TODAY FLOW
protocol TodayFactory {
    func makeEditSectionsViewController() -> UIViewController
    
}

//MARK: - SYMPTOM FLOW
protocol SymptomFactory {
    func makeAddSymptomViewController() -> UIViewController
    func makeSymptomDetailViewController(from symptom: Symptom) -> UIViewController
    func makeEditSymptom(from symptom: Symptom) -> UIViewController
}

// MARK: - PROFILE FLOW
protocol ProfileFactory {
    func makeProfileViewController(delegate: ProfileViewControllerDelegate) -> UIViewController
    func makeChangeCareRecipientViewController(delegate: ChangeCareRecipientViewControllerDelegate) -> UIViewController
    func makeMedicalRecordViewController() -> UIViewController
    
//    func makeEditCaregiverViewController() -> UIViewController
}

// MARK: - EVENTS FLOW
protocol EventsFactory {
    func makeAllEventsViewController() -> UIViewController
    func makeEventDetailSheet() -> UIViewController
    func makeAddEventViewController() -> UIViewController
}

// MARK: - MEDICATION FLOW
protocol MedicationFactory {
    func makeMedicationDetailSheet(delegate: MedicationDetailViewControllerDelegate) -> UIViewController
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
    func makeAllTasksViewController(onTaskSelected: ((TaskInstance) -> Void)?) -> UIViewController
    func makeAddTaskViewController() -> UIViewController
    func makeEditTaskViewController(task: RoutineTask) -> UIViewController
    func makeTaskDetailViewController(task: TaskInstance) -> UIViewController
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
//    func makeUserProfileViewController() -> UIViewController
    func makePrivacySecurityViewController() -> UIViewController
    func makeDevelopersViewController() -> UIViewController
}

// MARK: - SERVICES
protocol ServiceFactory {
    func makeBasicNeedsFacade() -> BasicNeedsFacade
    func makeCareRecipientFacade() -> CareRecipientFacade
}
