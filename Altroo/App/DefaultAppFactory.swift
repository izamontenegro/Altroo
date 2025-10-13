//
//  DefaultAppFactory.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 22/09/25.
//
import UIKit

// MARK: - DefaultAppFactory
final class DefaultAppFactory: AppFactory {
    private let dependencies: AppDependencies
    private let addPatientViewModel: AddPatientViewModel
    
    init(dependencies: AppDependencies) {
        self.dependencies = dependencies
        self.addPatientViewModel = AddPatientViewModel(careRecipientFacade: dependencies.careRecipientFacade)
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
        let vc = AssociatePatientViewController(viewModel: AssociatePatientViewModel())
        vc.delegate = delegate
        vc.title = "Associate Patient View"
        return vc
    }
    
    func makeTutorialAddSheet() -> UIViewController {
        let vc = TutorialAddSheet()
        return vc
    }
    
    func makePatientFormViewController(delegate: AssociatePatientViewControllerDelegate) -> UIViewController {
        let vc = PatientFormsViewController(viewModel: addPatientViewModel)
        vc.delegate = delegate
        vc.title = "Patient Forms"
        return vc
    }
    
    func makeComorbiditiesFormViewController(delegate: AssociatePatientViewControllerDelegate) -> UIViewController {
        let vc = ComorbiditiesFormsViewController(viewModel: addPatientViewModel)
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
    func makeSettingsViewController(delegate: SettingsViewControllerDelegate) -> UIViewController {
        let vc = SettingsViewController()
        vc.title = "Settings"
        vc.delegate = delegate
        return vc
    }
    
    func makeTodayViewController(delegate: TodayViewControllerDelegate) -> UIViewController {
        let vc = TodayViewController()
        vc.title = "Today"
        vc.delegate = delegate
        return vc
    }
    
    func makeHistoryViewController(delegate: HistoryViewControllerDelegate) -> UIViewController {
        let vc = HistoryViewController()
        vc.delegate = delegate
        vc.title = "History"
        return vc
    }
    
    func makeAnalysisViewController() -> UIViewController {
        let vc = AnalysisViewController()
        vc.title = "Analysis"
        return vc
    }
}

// MARK: - TodayFactory
extension DefaultAppFactory {
    func makeEditSectionsViewController() -> UIViewController {
        let vc = EditSectionViewController()
        return vc
    }
    
    func makeAddSymptomViewController() -> UIViewController {
        let vc = AddSymptomViewController()
        return vc
    }
}

//MARK: - ProfileFactory
extension DefaultAppFactory {
    func makeProfileViewController(delegate: ProfileViewControllerDelegate) -> UIViewController {
        let vc = CareRecipientProfileViewController()
        vc.delegate = delegate
        return vc
    }
    
    func makeChangeCaregiverViewController() -> UIViewController {
        let vc = ChangeCareRecipientViewController()
        return vc
    }
    
    func makeEditCaregiverViewController() -> UIViewController {
        let vc = EditCaregiverViewController()
        return vc
    }
    
    func makeMedicalRecordViewController() -> UIViewController {
        let vc = MedicalRecordViewController()
        return vc
    }
}

// MARK: - EventsFactory
extension DefaultAppFactory {
    func makeAllEventsViewController() -> UIViewController {
        let vc = AllEventViewController()
        return vc
    }
    func makeEventDetailSheet() -> UIViewController {
        let vc = EventDetailViewController()
        return vc
    }
    func makeAddEventViewController() -> UIViewController {
        let vc = AddEventViewController()
        return vc
    }
}

// MARK: - MedicationFactory
extension DefaultAppFactory {
    func makeAllMedicationViewController() -> UIViewController {
        let vc = AllMedicationViewController()
        return vc
    }
    func makeAddMedicationViewController() -> UIViewController {
        let vc = AddMedicationViewController()
        return vc
    }
    func makeMedicationDetailSheet(delegate: MedicationDetailViewControllerDelegate) -> UIViewController {
        let vc = MedicationDetailViewController()
        vc.delegate = delegate
        return vc
    }
    func makeMedicationTimeSheet() -> UIViewController {
        let vc = MedicationTimeSheetViewController()
        return vc
    }
    
}

// MARK: - BasicNeedsFactory
extension DefaultAppFactory {
    func makeStoolRecordViewController() -> UIViewController {
        let vc = StoolRecordViewController()
        return vc
    }
    func makeUrineRecordViewController() -> UIViewController {
        let vc = UrineRecordViewController()
        return vc
    }
    func makeMealRecordViewController() -> UIViewController {
        let vc = MealRecordViewController()
        return vc
    }
    func makeHydrationRecordSheet() -> UIViewController {
        let vc = HydrationRecordViewController()
        return vc
    }
}

// MARK: - TaskFactory
extension DefaultAppFactory {
    func makeAllTasksViewController(onTaskSelected: ((TaskInstance) -> Void)? = nil) -> UIViewController {
        let vm = AllTasksViewModel(taskService: dependencies.routineActivitiesFacade)
        let vc = AllTasksViewController(viewModel: vm, onTaskSelected: onTaskSelected)
        return vc
    }
    func makeAddTaskViewController() -> UIViewController {
        let vm = AddTaskViewModel(taskService: dependencies.routineActivitiesFacade)
        let vc = AddTaskViewController(viewModel: vm)
        return vc
    }
    func makeTaskDetailViewController(task: TaskInstance) -> UIViewController {
        let vc = TaskDetailViewController(task: task)
        vc.title = "Task"
        return vc
    }
}

// MARK: - MeasurementFactory
extension DefaultAppFactory {
    func makeRecordHeartRateSheet() -> UIViewController {
        let vc = RecordMeasurementViewController(measurementType: .heartRate)
        return vc
    }
    
    func makerRecordGlycemiaSheet() -> UIViewController {
        let vc = RecordMeasurementViewController(measurementType: .glycemia)
        return vc
    }
    
    func makeRecordBloodPressureSheet() -> UIViewController {
        let vc = RecordMeasurementViewController(measurementType: .bloodPressure)
        return vc
    }
    
    func makeRecordTemperatureSheet() -> UIViewController {
        let vc = RecordMeasurementViewController(measurementType: .temperature)
        return vc
    }
    
    func makeRecordSaturationSheet() -> UIViewController {
        let vc = RecordMeasurementViewController(measurementType: .saturation)
        return vc
    }
}

// MARK: - GeneralFactory
extension DefaultAppFactory {
    func makeAddIntervalSheet() -> UIViewController { // TODO:
        let vc = HistoryDetailViewController()
        return vc
    }
}

// MARK: - HistoryFactory
extension DefaultAppFactory {
    func makeSeeHistoryDetailSheet() -> UIViewController {
        let vc = HistoryDetailViewController()
        return vc
    }
}

//MARK: - SettingsFactory
extension DefaultAppFactory {
    func makeUserProfileViewController() -> UIViewController {
        let vc = UserProfileViewController()
        return vc
    }
    func makePrivacySecurityViewController() -> UIViewController {
        let vc = PrivacySecurityViewController()
        return vc
    }
    func makeDevelopersViewController() -> UIViewController{
        let vc = DevelopersViewController()
        return vc
    }
}

//MARK: - FacadeFactory
extension DefaultAppFactory {
    func makeBasicNeedsFacade() -> BasicNeedsFacade {
        dependencies.basicNeedsFacade
    }
    
    func makeCareRecipientFacade() -> CareRecipientFacade {
        dependencies.careRecipientFacade
    }
}

