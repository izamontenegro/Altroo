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
    private let patientService: PatientService
    private let factory: AppFactory
    
    var onRequestLogout: (() -> Void)?
    
    init(navigation: UINavigationController, patientService: PatientService, factory: AppFactory) {
        self.navigation = navigation
        self.patientService = patientService
        self.factory = factory
    }
    
    func start() {
        let vc = factory.makeTodayViewController(delegate: self)
        navigation.setViewControllers([vc], animated: false)
    }
    
    
    private func show(destination: TodayDestination) {
        switch destination {
        case .recordFeeding:
            let vc = factory.makeMealRecordViewController()
            navigation.pushViewController(vc, animated: true)
        case .recordHydration:
            let vc = factory.makeHydrationRecordSheet()
            vc.modalPresentationStyle = .pageSheet
            
            if let sheet = vc.sheetPresentationController {
                sheet.detents = [.medium()]
                sheet.prefersGrabberVisible = true
            }
            navigation.present(vc, animated: true)
        case .recordStool:
            let vc = factory.makeStoolRecordViewController()
            navigation.pushViewController(vc, animated: true)
        case .recordUrine:
            let vc = factory.makeUrineRecordViewController()
            navigation.pushViewController(vc, animated: true)
            
        case .recordHeartRate:
            let vc = factory.makeRecordHeartRateSheet()
            vc.modalPresentationStyle = .pageSheet
            
            if let sheet = vc.sheetPresentationController {
                sheet.detents = [.medium()]
                sheet.prefersGrabberVisible = true
            }
            navigation.present(vc, animated: true)
        case .recordGlycemia:
            let vc = factory.makerRecordGlycemiaSheet()
            vc.modalPresentationStyle = .pageSheet
            
            if let sheet = vc.sheetPresentationController {
                sheet.detents = [.medium()]
                sheet.prefersGrabberVisible = true
            }
            navigation.present(vc, animated: true)
        case .recordBloodPressure:
            let vc = factory.makeRecordBloodPressureSheet()
            vc.modalPresentationStyle = .pageSheet
            
            if let sheet = vc.sheetPresentationController {
                sheet.detents = [.medium()]
                sheet.prefersGrabberVisible = true
            }
            navigation.present(vc, animated: true)
        case .recordTemperature:
            let vc = factory.makeRecordTemperatureSheet()
            vc.modalPresentationStyle = .pageSheet
            
            if let sheet = vc.sheetPresentationController {
                sheet.detents = [.medium()]
                sheet.prefersGrabberVisible = true
            }
            navigation.present(vc, animated: true)
        case .recordSaturation:
            let vc = factory.makeRecordSaturationSheet()
            vc.modalPresentationStyle = .pageSheet
            
            if let sheet = vc.sheetPresentationController {
                sheet.detents = [.medium()]
                sheet.prefersGrabberVisible = true
            }
            navigation.present(vc, animated: true)
            
        case .seeAllTasks:
            let vc = factory.makeAllTasksViewController { [weak self] task in
                self?.goToTaskDetail(with: task)
            }
            navigation.pushViewController(vc, animated: true)
        case .addNewTask:
            let vc = factory.makeAddTaskViewController() as! AddTaskViewController
            vc.coordinator = self
            navigation.pushViewController(vc, animated: true)
        case .taskDetail:
            //TODO: Take this out
            print("ok")
            
        case .seeAllMedication:
            let vc = factory.makeAllMedicationViewController()
            navigation.pushViewController(vc, animated: true)
        case .addNewMedication:
            let vc = factory.makeAddMedicationViewController()
            navigation.pushViewController(vc, animated: true)
        case .checkMedicationDone:
            let nav = UINavigationController()

            let medicationDetailCood = MedicationDetailCoordinator(
                navigation: nav, patientService: patientService, factory: factory
            )
            add(child: medicationDetailCood)
            
            nav.modalPresentationStyle = .pageSheet
                if let sheet = nav.sheetPresentationController {
                    sheet.detents = [.medium()]
                    sheet.prefersGrabberVisible = true
                }

                navigation.present(nav, animated: true)
                medicationDetailCood.start()
            
        case .seeAllEvents:
            let vc = factory.makeAllEventsViewController()
            navigation.pushViewController(vc, animated: true)
        case .addNewEvent:
            let vc = factory.makeAddEventViewController()
            navigation.pushViewController(vc, animated: true)
            
        case .editSection:
            let vc = factory.makeEditSectionsViewController()
            navigation.pushViewController(vc, animated: true)
            
        case .careRecipientProfile:
            let profileCoord = ProfileCoordinator(
                navigation: navigation, patientService: patientService, factory: factory
            )
            add(child: profileCoord); profileCoord.start()
            
        case .addSymptom:
            let vc = factory.makeAddSymptomViewController()
            navigation.pushViewController(vc, animated: true)
        }
    }
}

extension TodayCoordinator: TodayViewControllerDelegate {
    func goToCareRecipientProfileView() {
        show(destination: .careRecipientProfile)
    }
    
    func goToEditSectionView() {
        show(destination: .editSection)
    }
    
    func goToRecordFeeding() {
        show(destination: .recordFeeding)
    }
    
    func goToRecordHydration() {
        show(destination: .recordHydration)
    }
    
    func goToRecordStool() {
        show(destination: .recordStool)
    }
    
    func goToRecordUrine() {
        show(destination: .recordUrine)
    }
    
    func goToRecordHeartRate() {
        show(destination: .recordHeartRate)
    }
    
    func goToRecordGlycemia() {
        show(destination: .recordGlycemia)
    }
    
    func goToRecordBloodPressure() {
        show(destination: .recordBloodPressure)
    }
    
    func goToRecordTemperature() {
        show(destination: .recordTemperature)
    }
    
    func goToRecordSaturation() {
        show(destination: .recordSaturation)
    }
    
    func goToSeeAllTasks() {
        show(destination: .seeAllTasks)
    }
    
    func goToAddNewTask() {
        show(destination: .addNewTask)
    }
    
    func goToTaskDetail(with task: MockTask) {
        let vc = factory.makeTaskDetailViewController(task: task)
        
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .pageSheet
        
        if let sheet = nav.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
        }
        navigation.present(nav, animated: true)
    }
    
    func goToSeeAllMedication() {
        show(destination: .seeAllMedication)
    }
    
    func goToAddNewMedication() {
        show(destination: .addNewMedication)
    }
    
    func goToCheckMedicationDone() {
        show(destination: .checkMedicationDone)
    }
    
    func goToSeeAllEvents() {
        show(destination: .seeAllEvents)
    }
    
    func goToAddNewEvent() {
        show(destination: .addNewEvent)
    }
    
    func goToAddNewSymptom() {
        show(destination: .addSymptom)
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
}

extension TodayCoordinator: AddTaskNavigationDelegate {
    func didFinishAddingTask() {
        let superVC = navigation.viewControllers.first!
        let vc = factory.makeAllTasksViewController { [weak self] task in
            self?.goToTaskDetail(with: task)
        }
        navigation.setViewControllers([superVC, vc], animated: true)
    }
}
