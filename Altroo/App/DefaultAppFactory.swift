//
//  DefaultAppFactory.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 22/09/25.
//
import UIKit

// MARK: - DefaultAppFactory
final class DefaultAppFactory: AppFactory {
    private let patientService: PatientService
    
    init(patientService: PatientService) {
        self.patientService = patientService
    }
}

// MARK: - OnboardingFactory
extension DefaultAppFactory {
    func makeWelcomeViewController(delegate: WelcomeViewControllerDelegate) -> UIViewController {
        let vc = WelcomeViewController()
        vc.delegate = delegate
        vc.title = "Welcome!"
        return vc
    }
}

// MARK: - AssociatePatientFactory
extension DefaultAppFactory {

    func makeAssociatePatientViewController(delegate: AssociatePatientViewControllerDelegate) -> UIViewController {
        let vc = AssociatePatientViewController(viewModel: AssociatePatientViewModel(patientService: patientService))
        vc.delegate = delegate
        vc.title = "Associate Patient View"
        return vc
    }
    
    func makeTutorialAddSheet() -> UIViewController {
        let vc = TutorialAddSheet()
        return vc
    }
    
    func makePatientFormViewController(delegate: AssociatePatientViewControllerDelegate) -> UIViewController {
        let basicNeeds = BasicNeedsFacadeMock()
        let routineActivities = RoutineActivitiesFacadeMock()
        let persistence = CoreDataService()

        let facade = CareRecipientFacade(
            basicNeedsFacade: basicNeeds,
            routineActivitiesFacade: routineActivities,
            persistenceService: persistence
        )
        let vc = PatientFormsViewController(viewModel: PatientFormsViewModel(careRecipientFacade: facade))
        vc.delegate = delegate
        vc.title = "Patient Forms"
        return vc
    }
    
    func makeComorbiditiesFormViewController(delegate: AssociatePatientViewControllerDelegate) -> UIViewController {
        let vc = ComorbiditiesFormsViewController()
        vc.delegate = delegate
        vc.title = "Comorbidities Forms"
        return vc
    }
    
    func makeShiftFormViewController(delegate: ShiftFormsViewControllerDelegate) -> UIViewController {
        let vc = ShiftFormViewController()
        vc.delegate = delegate
        vc.title = "Shift Forms"
        return vc
    }
}

// MARK: - MainFlowFactory
extension DefaultAppFactory {
    func makeSettingsViewController() -> UIViewController {
        let vc = SettingsViewController()
        vc.title = "Settings"
        return vc
    }
    
    func makeTodayViewController(delegate: TodayViewControllerDelegate) -> UIViewController {
        let vc = TodayViewController()
        vc.title = "Today"
        vc.delegate = delegate
        return vc
    }
    
    func makeHistoryViewController() -> UIViewController {
        let vc = HistoryViewController()
        vc.title = "History"
        return vc
    }
    
    func makeAnalysisViewController() -> UIViewController {
        let vc = AnalysisViewController()
        vc.title = "Analysis"
        return vc
    }
}

// MARK: - AddItemFactory
extension DefaultAppFactory {
    func makeAddItemSheet(delegate: AddItemsSheetViewControllerDelegate) -> UIViewController {
        let vc = AddItemsSheetViewController()
        vc.title = "Add"
        vc.delegate = delegate
        return vc
    }
    
    func makeAddBasicNeedsSheet() -> UIViewController {
        let vc = AddBasicNeedsViewController()
        return vc
    }
    
    func makeAddMeasurementSheet() -> UIViewController {
        let vc = AddMeasurementViewController()
        return vc
    }
    
    func makeAddMedicationViewController() -> UIViewController {
        let vc = AddMedicationViewController()
        return vc
    }
    
    func makeAddRoutineActivityViewController() -> UIViewController {
        let vc = AddRoutineActivityViewController()
        return vc
    }
    
    func makeAddSymptomViewController() -> UIViewController {
        let vc = AddSymptomViewController()
        return vc
    }
    
    func makeAddEventViewController() -> UIViewController {
        let vc = AddEventViewController()
        return vc
    }
}

// MARK: - ProfileFactory
extension DefaultAppFactory {
    func makeProfileViewController() -> UIViewController {
        let vc = ProfileViewController()
        return vc
    }
}

// MARK: - EventsFactory
extension DefaultAppFactory {
    func makeAllEventsViewController() -> UIViewController { // TODO:
        let vc = AddBasicNeedsViewController()
        return vc
    }
    func makeEventDetailSheet() -> UIViewController { // TODO:
        let vc = AddBasicNeedsViewController()
        return vc
    }
}

// MARK: - MedicationFactory
extension DefaultAppFactory {
    func makeMedicationDetailSheet() -> UIViewController { // TODO:
        let vc = AddBasicNeedsViewController()
        return vc
    }
    func makeMedicationTimeSheet() -> UIViewController { // TODO:
        let vc = AddBasicNeedsViewController()
        return vc
    }
}

// MARK: - BasicNeedsFactory
extension DefaultAppFactory {
    func makeStoolRecordViewController() -> UIViewController { // TODO:
        let vc = AddBasicNeedsViewController()
        return vc
    }
    func makeUrineRecordViewController() -> UIViewController { // TODO:
        let vc = AddBasicNeedsViewController()
        return vc
    }
    func makeMealRecordViewController() -> UIViewController { // TODO:
        let vc = AddBasicNeedsViewController()
        return vc
    }
    func makeHydrationRecordSheet() -> UIViewController { // TODO:
        let vc = AddBasicNeedsViewController()
        return vc
    }
}

// MARK: - RoutineActivitiesFactory
extension DefaultAppFactory {
    func makeAllRoutineActivitiesViewController() -> UIViewController { // TODO:
        let vc = AddBasicNeedsViewController()
        return vc
    }
}

// MARK: - MeasurementFactory
extension DefaultAppFactory {
    func makeRecordMeasurementSheet() -> UIViewController { // TODO:
        let vc = AddBasicNeedsViewController()
        return vc
    }
}

// MARK: - GeneralFactory
extension DefaultAppFactory {
    func makeAddIntervalSheet() -> UIViewController { // TODO:
        let vc = AddBasicNeedsViewController()
        return vc
    }
}

// MARK: - HistoryFactory
extension DefaultAppFactory {
    func makeSeeHistoryDetailSheet() -> UIViewController { // TODO:
        let vc = AddBasicNeedsViewController()
        return vc
    }
}
