//
//  TodayCoordinator.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 22/09/25.
//

import UIKit

final class TodayCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    var navigation: UINavigationController
    
    private let factory: AppFactory
    
    var onRequestLogout: (() -> Void)?
    weak var parentCoordinator: MainCoordinator?
    
    init(navigation: UINavigationController, factory: AppFactory) {
        self.navigation = navigation
        self.factory = factory
    }
    
    func start() {
        let vc = factory.makeTodayViewController(delegate: self)
        navigation.setViewControllers([vc], animated: false)
    }
    
    
    private func makeViewController(for destination: TodayDestination) -> UIViewController? {
        switch destination {
            
            // MARK: - RECORDS
        case .recordFeeding:
            let vc = factory.makeMealRecordViewController() as! MealRecordViewController
            vc.delegate = self
            return vc
            
        case .recordHydration:
            let vc = factory.makeHydrationRecordSheet()
            if let hydrationVC = vc as? HydrationRecordViewController {
                hydrationVC.onDismiss = { [weak self] in
                    guard let self else { return }
                    if let todayVC = self.navigation.viewControllers
                        .compactMap({ $0 as? TodayViewController })
                        .first {
                        todayVC.viewModel.fetchWaterMeasure()
                    }
                }
            }
            return vc
            
        case .recordUrine:
            let vc = factory.makeUrineRecordViewController() as! UrineRecordViewController
            vc.delegate = self
            return vc
            
        case .recordStool:
            let vc = factory.makeStoolRecordViewController() as! StoolRecordViewController
            vc.delegate = self
            return vc
            
        case .recordHeartRate:
            return factory.makeRecordHeartRateSheet()
            
        case .recordGlycemia:
            return factory.makerRecordGlycemiaSheet()
            
        case .recordBloodPressure:
            return factory.makeRecordBloodPressureSheet()
            
        case .recordTemperature:
            return factory.makeRecordTemperatureSheet()
            
        case .recordSaturation:
            return factory.makeRecordSaturationSheet()
            
            // MARK: - TASKS
        case .seeAllTasks:
            let vc = factory.makeAllTasksViewController() as! AllTasksViewController
            vc.coordinator = self
            return vc
            
        case .addNewTask:
            let vc = factory.makeAddTaskViewController() as! AddTaskViewController
            vc.coordinator = self
            return vc
            
        case .taskDetail(let task):
            let vc = factory.makeTaskDetailViewController(mode: .instance(task)) as! TaskDetailViewController
            vc.onEditTapped = { [weak self] task in
                self?.goTo(.editTask(task))
            }
            vc.onDeleteTapped = { [weak self] in
                guard let self else { return }
                if let allTasksVC = self.navigation.viewControllers
                    .compactMap({ $0 as? AllTasksViewController })
                    .first {
                    allTasksVC.viewModel.loadLateTasks()
                }
            }
            return vc
        case .templateDetail:
            return nil
        case .editTask(let task):
            let vc = factory.makeEditTaskViewController(task: task) as! EditTaskViewController
            vc.coordinator = self
            return vc
            
            // MARK: - SYMPTOMS
        case .addSymptom:
            let vc = factory.makeAddSymptomViewController() as! AddSymptomViewController
            vc.coordinator = self
            return vc
            
        case .symptomDetail(let symptom):
            let vc = factory.makeSymptomDetailViewController(from: symptom) as! SymptomDetailViewController
            vc.onEditTapped = { [weak self] symptom in
                self?.goTo(.editSymptom(symptom))
            }
            return vc
            
        case .editSymptom(let symptom):
            let vc = factory.makeEditSymptom(from: symptom) as! EditSymptomViewController
            vc.coordinator = self
            return vc
            
            // MARK: - OTHER
        case .seeAllMedication: return factory.makeAllMedicationViewController()
        case .addNewMedication: return factory.makeAddMedicationViewController()
        case .seeAllEvents: return factory.makeAllEventsViewController()
        case .addNewEvent: return factory.makeAddEventViewController()
        case .editSection: return factory.makeEditSectionsViewController()
        case .privacyPolicy: return factory.makePrivacyViewController() as! PrivacyViewController
        case .legalNotice: return factory.makePolicyViewController() as! PolicyViewController
            
            // MARK: - CHILD COORDINATORS
        case .careRecipientProfile:
            guard let main = parentCoordinator else { return nil }
            let profileCoord = main.makeProfileCoordinator(using: navigation)
            add(child: profileCoord)
            profileCoord.start()
            return nil
            
        case .checkMedicationDone:
            let nav = UINavigationController()
            let medicationDetailCoord = MedicationDetailCoordinator(navigation: nav, factory: factory)
            add(child: medicationDetailCoord)
            presentSheet(nav, detents: [almostFullDetent()])
            medicationDetailCoord.start()
            return nil
        }
    }
}


// MARK: - Delegates
extension TodayCoordinator: TodayViewControllerDelegate {
    
    func goTo(_ destination: TodayDestination) {
        switch destination {
            
            // SHORT SHEETS
        case .recordFeeding, .recordHydration, .recordStool, .recordUrine,
                .recordHeartRate, .recordGlycemia, .recordBloodPressure, .recordTemperature, .recordSaturation:

            guard let root = makeViewController(for: destination) else { return }
            presentSheet(root, detents: [almostFullDetent()])
            
            //MEDIUM SHEETS
        case .taskDetail, .symptomDetail:
            guard let root = makeViewController(for: destination) else { return }
            presentSheet(root, detents: [.medium()])
            
        case .templateDetail(let task):
            openTaskTemplateDetail(for: task)
            
            //FULL SHEETS
        case .addNewTask, .addSymptom,
                .editTask, .editSymptom:
            guard let root = makeViewController(for: destination) else { return }
            presentSheet(root, detents: [.large()])
            
            // PUSHES
        case .seeAllTasks,
                .seeAllMedication, .seeAllEvents,
                .addNewMedication, .addNewEvent,
                .editSection,
                .privacyPolicy, .legalNotice:
            
            guard let vc = makeViewController(for: destination) else { return }
            push(vc)
            
            
            // CHILD COORDINATORS
        case .careRecipientProfile, .checkMedicationDone:
            _ = makeViewController(for: destination)
        }
    }
    
}

extension TodayCoordinator: TaskCardNavigationDelegate {
    func taskCardDidSelect(_ task: TaskInstance) {
        goTo(.taskDetail(task))
    }
}

extension TodayCoordinator: AddTaskNavigationDelegate {
    func didFinishAddingTask() {
        navigation.dismiss(animated: true)
        let superVC = navigation.viewControllers.first!
        let vc = factory.makeAllTasksViewController() as! AllTasksViewController
        vc.coordinator = self
        navigation.setViewControllers([superVC, vc], animated: true)
    }
}

extension TodayCoordinator: UrineRecordNavigationDelegate {
    func didFinishAddingUrineRecord() {
        navigation.popToRootViewController(animated: true)
    }
}

extension TodayCoordinator: StoolRecordNavigationDelegate {
    func didFinishAddingStoolRecord() {
        navigation.popToRootViewController(animated: true)
    }
}

extension TodayCoordinator: MealRecordNavigationDelegate {
    func didFinishAddingMealRecord() {
        navigation.popToRootViewController(animated: true)
    }
}


// MARK: - Navigation Helpers
private extension TodayCoordinator {
    func openTaskTemplateDetail(for task: RoutineTask) {
        let vc = factory.makeTaskDetailViewController(mode: .template(task)) as! TaskDetailViewController
        
        vc.onEditTapped = { [weak self] task in
            self?.goTo(.editTask(task))
        }
        
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .pageSheet
        
        if let sheet = nav.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
        }
        
        navigation.present(nav, animated: true)
    }
        
    func push(_ vc: UIViewController) {
        navigation.pushViewController(vc, animated: true)
    }
    
    func presentSheet(
        _ root: UIViewController,
        detents: [UISheetPresentationController.Detent]
    ) {
        let nav = UINavigationController(rootViewController: root)
        nav.modalPresentationStyle = .pageSheet
        if let sheet = nav.sheetPresentationController {
            sheet.detents = detents
            sheet.prefersGrabberVisible = true
        }
        navigation.present(nav, animated: true)
    }
    
    func almostFullDetent() -> UISheetPresentationController.Detent {
        .custom(identifier: .init("almostFull")) { context in
            context.maximumDetentValue * 0.9
        }
    }
}

enum TodayDestination {
    case recordFeeding
    case recordHydration
    case recordStool
    case recordUrine
    
    case recordHeartRate
    case recordGlycemia
    case recordBloodPressure
    case recordTemperature
    case recordSaturation
    
    case seeAllTasks
    case addNewTask
    case taskDetail(TaskInstance)
    case templateDetail(RoutineTask)
    
    case editTask(RoutineTask)
    
    case seeAllMedication
    case addNewMedication
    
    case seeAllEvents
    case addNewEvent
    
    case addSymptom
    case symptomDetail(Symptom)
    case editSymptom(Symptom)
    
    case editSection
    
    case careRecipientProfile
    case checkMedicationDone
    
    case privacyPolicy
    case legalNotice
}
