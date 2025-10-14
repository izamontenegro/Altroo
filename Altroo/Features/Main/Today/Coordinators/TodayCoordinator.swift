//
//  TodayCoordinator.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 22/09/25.
//

import UIKit

final class TodayCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    private let navigation: UINavigationController
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
        case .recordFeeding: return factory.makeMealRecordViewController()
        case .recordHydration: return factory.makeHydrationRecordSheet()
        case .recordStool: return factory.makeStoolRecordViewController()
        case .recordUrine: return factory.makeUrineRecordViewController()
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
        case .addSymptom: return factory.makeAddSymptomViewController()
            
        case .careRecipientProfile:
            let profileCoord = ProfileCoordinator(navigation: navigation, factory: factory)
            add(child: profileCoord)
            profileCoord.start()
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
        }
    }
    
    private func openTaskDetail(for task: TaskInstance)  {
        let vc = factory.makeTaskDetailViewController(task: task)
        
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .pageSheet
        
        if let sheet = nav.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
        }
        navigation.present(nav, animated: true)
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
}


enum TodayDestination {
    case careRecipientProfile
    case editSection
    case recordFeeding, recordHydration, recordStool, recordUrine
    case recordHeartRate, recordGlycemia, recordBloodPressure, recordTemperature, recordSaturation
    
    case seeAllTasks, addNewTask, taskDetail
    
    case seeAllMedication, addNewMedication, checkMedicationDone
    case seeAllEvents, addNewEvent
    case addSymptom
    
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
