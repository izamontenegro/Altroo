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
    func makeWelcome(delegate: WelcomeViewControllerDelegate) -> UIViewController {
        let vc = WelcomeViewController()
        vc.delegate = delegate
        vc.title = "Welcome!"
        return vc
    }
}

// MARK: - AssociatePatientFactory
extension DefaultAppFactory {

    func makeAssociatePatient(delegate: AssociatePatientViewControllerDelegate) -> UIViewController {
        let vc = AssociatePatientViewController()
        vc.delegate = delegate
        vc.title = "Associate Patient View"
        return vc
    }
    
    func makeTutorialAddSheet() -> UIViewController {
        let vc = TutorialAddSheet()
        return vc
    }
    
    func makePatientForm(delegate: AssociatePatientViewControllerDelegate) -> UIViewController {
        let vc = PatientFormsViewController()
        vc.delegate = delegate
        vc.title = "Patient Forms"
        return vc
    }
    
    func makeComorbiditiesForms(delegate: AssociatePatientViewControllerDelegate) -> UIViewController {
        let vc = ComorbiditiesFormsViewController()
        vc.delegate = delegate
        vc.title = "Comorbidities Forms"
        return vc
    }
    
    func makeShiftForms(delegate: ShiftFormsViewControllerDelegate) -> UIViewController {
        let vc = ShiftFormViewController()
        vc.delegate = delegate
        vc.title = "Shift Forms"
        return vc
    }
}

// MARK: - MainFlowFactory
extension DefaultAppFactory {
    func makeSettings() -> UIViewController {
        let vc = SettingsViewController()
        vc.title = "Settings"
        return vc
    }
    
    func makeToday(delegate: TodayViewControllerDelegate) -> UIViewController {
        let vc = TodayViewController()
        vc.title = "Today"
        vc.delegate = delegate
        return vc
    }
    
    func makeHistory() -> UIViewController {
        let vc = HistoryViewController()
        vc.title = "History"
        return vc
    }
    
    func makeAnalysis() -> UIViewController {
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
    
    func makeAddMedication() -> UIViewController {
        let vc = AddMedicationViewController()
        return vc
    }
    
    func makeAddRoutineActivity() -> UIViewController {
        let vc = AddRoutineActivityViewController()
        return vc
    }
    
    func makeAddSymptom() -> UIViewController {
        let vc = AddSymptomViewController()
        return vc
    }
    
    func makeAddEvent() -> UIViewController {
        let vc = AddEventViewController()
        return vc
    }
}

// MARK: - ProfileFactory
extension DefaultAppFactory {
    func makeProfile() -> UIViewController {
        let vc = ProfileViewController()
        return vc
    }
}

// MARK: - EventsFactory
extension DefaultAppFactory {
    func makeSeeAllEvents() -> UIViewController { // TODO:
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
    func makeStoolRecord() -> UIViewController { // TODO:
        let vc = AddBasicNeedsViewController()
        return vc
    }
    func makeUrineRecord() -> UIViewController { // TODO:
        let vc = AddBasicNeedsViewController()
        return vc
    }
    func makeMealRecord() -> UIViewController { // TODO:
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
    func makeSeeAllRoutineActivities() -> UIViewController { // TODO:
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
