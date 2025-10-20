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
    private let userService: UserServiceProtocol
    private let addPatientViewModel: AddPatientViewModel
    
    init(dependencies: AppDependencies, userService: UserServiceProtocol) {
        self.dependencies = dependencies
        self.userService = userService
        self.addPatientViewModel = AddPatientViewModel(careRecipientFacade: dependencies.careRecipientFacade, userService: userService)
    }
}

// MARK: - OnboardingFactory
extension DefaultAppFactory {
    func makeWelcomeOnboardingViewController(delegate: WelcomeOnboardingViewControllerDelegate) -> UIViewController {
        let vc = WelcomeOnboardingViewController()
        vc.delegateOnboarding = delegate
        vc.title = "Welcome!"
        return vc
    }
}

// MARK: - AssociatePatientFactory
extension DefaultAppFactory {
    
    func makeAssociatePatientViewController(delegate: AssociatePatientViewControllerDelegate) -> UIViewController {
        let vc = AssociatePatientViewController(viewModel: AssociatePatientViewModel(userService: userService))
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
        vc.title = "Perfil do Assistido"
        return vc
    }
    
    func makeComorbiditiesFormViewController(delegate: AssociatePatientViewControllerDelegate) -> UIViewController {
        let vc = ComorbiditiesFormsViewController(viewModel: addPatientViewModel)
        vc.delegate = delegate
        vc.title = "Comorbidades"
        return vc
    }
    
    func makeShiftFormViewController(delegate: ShiftFormsViewControllerDelegate) -> UIViewController {
        let vc = ShiftFormViewController(viewModel: addPatientViewModel)
        vc.delegate = delegate
        vc.title = "Turnos"
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
        let vm = TodayViewModel(careRecipientFacade: dependencies.careRecipientFacade, userService: dependencies.userService)
        let vc = TodayViewController(viewModel: vm)
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
    
    
}

//MARK: SymptomFactory
extension DefaultAppFactory {
    func makeAddSymptomViewController() -> UIViewController {
        let vm = AddSymptomViewModel(careRecipientFacade: dependencies.careRecipientFacade, userService: dependencies.userService)
        let vc = AddSymptomViewController(viewModel: vm)
        return vc
    }
    
    func makeSymptomDetailViewController(from symptom: Symptom) -> UIViewController {
        let vc = SymptomDetailViewController(symptom: symptom)
        return vc
    }
    
    func makeEditSymptom(from symptom: Symptom) -> UIViewController {
        let vm = EditSymptomViewModel(careRecipientFacade: dependencies.careRecipientFacade, userService: dependencies.userService, symptom: symptom)
        let vc = EditSymptomViewController(viewModel: vm)
        return vc
    }

}

//MARK: - ProfileFactory
extension DefaultAppFactory {
    func makeProfileViewController(delegate: ProfileViewControllerDelegate) -> UIViewController {
        let vm = CareRecipientProfileViewModel(userService: dependencies.userService, coreDataService: dependencies.coreDataService)
        let vc = CareRecipientProfileViewController(viewModel: vm)
        vc.delegate = delegate
        return vc
    }
    
    func makeChangeCareRecipientViewController(delegate: ChangeCareRecipientViewControllerDelegate) -> UIViewController {
        let vm = ChangeCareRecipientViewModel(userService: dependencies.userService, coreDataService: dependencies.coreDataService)
        let vc = ChangeCareRecipientViewController(viewModel: vm)
        (vc as? ChangeCareRecipientViewController)?.delegate = delegate
        return vc
    }
   
    func makeMedicalRecordViewController() -> UIViewController {
        let vm = MedicalRecordViewModel(userService: dependencies.userService)
        let vc = MedicalRecordViewController(viewModel: vm)
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
        let vm = StoolRecordViewModel(stoolService: dependencies.basicNeedsFacade, coreDataService: dependencies.coreDataService, userService: dependencies.userService)
        let vc = StoolRecordViewController(viewModel: vm)
        return vc
    }
    func makeUrineRecordViewController() -> UIViewController {
        let vm = UrineRecordViewModel(urineService: dependencies.basicNeedsFacade, coreDataService: dependencies.coreDataService, userService: dependencies.userService)
        let vc = UrineRecordViewController(viewModel: vm)

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
        let vm = AllTasksViewModel(taskService: dependencies.routineActivitiesFacade, userService: dependencies.userService)
        let vc = AllTasksViewController(viewModel: vm, onTaskSelected: onTaskSelected)
        return vc
    }
    func makeAddTaskViewController() -> UIViewController {
        let vm = AddTaskViewModel(taskService: dependencies.routineActivitiesFacade, userService: dependencies.userService)
        let vc = AddTaskViewController(viewModel: vm)
        return vc
    }
    
    func makeEditTaskViewController(task: RoutineTask) -> UIViewController {
        let vm = EditTaskViewModel(task: task, taskService: dependencies.routineActivitiesFacade, userService: dependencies.userService)
        let vc = EditTaskViewController(viewModel: vm)
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

