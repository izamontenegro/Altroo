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
    private let factory: AppFactory // <- NOVO
    
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
            navigation.pushViewController(vc, animated: true)
        case .recordStool:
            let vc = factory.makeStoolRecordViewController()
            navigation.pushViewController(vc, animated: true)
        case .recordUrine:
            let vc = factory.makeUrineRecordViewController()
            navigation.pushViewController(vc, animated: true)
            
        case .recordHeartRate:
            let vc = factory.makeRecordHeartRateSheet()
            navigation.pushViewController(vc, animated: true)
        case .recordGlycemia:
            let vc = factory.makerRecordGlycemiaSheet()
            navigation.pushViewController(vc, animated: true)
        case .recordBloodPressure:
            let vc = factory.makeRecordBloodPressureSheet()
            navigation.pushViewController(vc, animated: true)
        case .recordTemperature:
            let vc = factory.makeRecordTemperatureSheet()
            navigation.pushViewController(vc, animated: true)
        case .recordSaturation:
            let vc = factory.makeRecordSaturationSheet()
            navigation.pushViewController(vc, animated: true)
            
        case .seeAllTasks:
            let vc = factory.makeAllTasksViewController()
            navigation.pushViewController(vc, animated: true)
        case .addNewTask:
            let vc = factory.makeAddTaskViewController()
            navigation.pushViewController(vc, animated: true)
            
        case .seeAllMedication:
            let vc = factory.makeAllMedicationViewController()
            navigation.pushViewController(vc, animated: true)
        case .addNewMedication:
            let vc = factory.makeAddMedicationViewController()
            navigation.pushViewController(vc, animated: true)
        case .checkMedicationDone:
            let vc = factory.makeMedicationTimeSheet()
            navigation.pushViewController(vc, animated: true)
            
        case .seeAllEvents:
            let vc = factory.makeAllEventsViewController()
            navigation.pushViewController(vc, animated: true)
        case .addNewEvent:
            let vc = factory.makeAddEventViewController()
            navigation.pushViewController(vc, animated: true)
            
        case .careRecipientProfile:
            let vc = factory.makeProfileViewController()
            navigation.pushViewController(vc, animated: true)
        }
    }
}

extension TodayCoordinator: TodayViewControllerDelegate {
    func goToCareRecipientProfileView() {
        show(destination: .careRecipientProfile)
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
}


enum TodayDestination {
    case careRecipientProfile
    
    case recordFeeding, recordHydration, recordStool, recordUrine
    
    case recordHeartRate, recordGlycemia, recordBloodPressure, recordTemperature, recordSaturation
    
    case seeAllTasks, addNewTask
    
    case seeAllMedication, addNewMedication, checkMedicationDone
    
    case seeAllEvents, addNewEvent
}
