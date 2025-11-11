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
            
        case .recordHeartRate: return factory.makeRecordHeartRateSheet()
        case .recordGlycemia: return factory.makerRecordGlycemiaSheet()
        case .recordBloodPressure: return factory.makeRecordBloodPressureSheet()
        case .recordTemperature: return factory.makeRecordTemperatureSheet()
        case .recordSaturation: return factory.makeRecordSaturationSheet()
            
        case .seeAllTasks:
            return factory.makeAllTasksViewController { [weak self] task in
                self?.openTaskDetail(for: task)
            }
            
        case .addNewTask:
            let vc = factory.makeAddTaskViewController() as! AddTaskViewController
            vc.coordinator = self
            return vc
            
        case .seeAllMedication: return factory.makeAllMedicationViewController()
        case .addNewMedication: return factory.makeAddMedicationViewController()
        case .seeAllEvents: return factory.makeAllEventsViewController()
        case .addNewEvent: return factory.makeAddEventViewController()
        case .editSection: return factory.makeEditSectionsViewController()
        case .addSymptom:
            let vc = factory.makeAddSymptomViewController() as! AddSymptomViewController
            vc.coordinator = self
            return vc
            
        case .careRecipientProfile:
            let profileCoord = ProfileCoordinator(navigation: navigation, factory: factory, associateFactory: factory)
            add(child: profileCoord); profileCoord.start()
            return nil
            
        case .checkMedicationDone:
            let nav = UINavigationController()
            let medicationDetailCoord = MedicationDetailCoordinator(navigation: nav, factory: factory)
            add(child: medicationDetailCoord)
            presentSheet(nav, from: navigation)
            medicationDetailCoord.start()
            return nil
            
        case .taskDetail:
            return nil
            
        case .symptomDetail:
            return nil
        }
    }
    
    private func openTaskDetail(for task: TaskInstance)  {
        let vc = factory.makeTaskDetailViewController(task: task) as! TaskDetailViewController
        vc.onEditTapped = {[weak self] task in
            guard let taskTemplate = task.template else { return }
            self?.goToEditTask(taskTemplate)
        }
        
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .pageSheet
        
        if let sheet = nav.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
        }
        navigation.present(nav, animated: true)
    }
    
    private func goToEditSymptom(_ symptom: Symptom) {
        let vc = factory.makeEditSymptom(from: symptom) as! EditSymptomViewController
        vc.coordinator = self
        navigation.pushViewController(vc, animated: true)
    }
    
    private func goToEditTask(_ task: RoutineTask) {
        let vc = factory.makeEditTaskViewController(task: task) as! EditTaskViewController
        vc.coordinator = self
        navigation.pushViewController(vc, animated: true)
    }
}

extension TodayCoordinator: TodayViewControllerDelegate {
    
    func goTo(_ destination: TodayDestination) {
        guard let vc = makeViewController(for: destination) else { return }
        
        if destination.isSheet {
            presentSheet(vc, from: navigation)
        } else {
            navigation.pushViewController(vc, animated: true)
        }
    }
    
    func goToSymptomDetail(with symptom: Symptom) {
        let vc = factory.makeSymptomDetailViewController(from: symptom) as! SymptomDetailViewController
        vc.onEditTapped = {[weak self] symptom in
            self?.goToEditSymptom(symptom)
        }
        
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .pageSheet
        
        if let sheet = nav.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
        }
        navigation.present(nav, animated: true)
    }
}


enum TodayDestination {
    case careRecipientProfile
    case editSection
    case recordFeeding, recordHydration, recordStool, recordUrine
    case recordHeartRate, recordGlycemia, recordBloodPressure, recordTemperature, recordSaturation
    
    case seeAllTasks, addNewTask, taskDetail
    
    case seeAllMedication, addNewMedication, checkMedicationDone
    case seeAllEvents, addNewEvent
    case addSymptom, symptomDetail
    
    var isSheet: Bool {
        switch self {
        case .recordHydration, .recordHeartRate, .recordGlycemia,
                .recordBloodPressure, .recordTemperature, .recordSaturation:
            return true
        default:
            return false
        }
    }
}

extension TodayCoordinator: AddTaskNavigationDelegate {
    func didFinishAddingTask() {
        let superVC = navigation.viewControllers.first!
        let vc = factory.makeAllTasksViewController { [weak self] task in
            self?.openTaskDetail(for: task)
        }
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
