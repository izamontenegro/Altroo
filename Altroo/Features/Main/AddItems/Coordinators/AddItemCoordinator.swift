//
//  AddItemCoordinator.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 22/09/25.
//

import UIKit

final class AddItemCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    private let navigation: UINavigationController
    private let patientService: PatientService
    private let factory: AddItemFactory

    init(navigation: UINavigationController, patientService: PatientService, factory: AppFactory) {
        self.navigation = navigation
        self.patientService = patientService
        self.factory = factory
    }

    func start() {
        let vc = factory.makeAddItemSheet(delegate: self)
        navigation.setViewControllers([vc], animated: false)
    }

}

extension AddItemCoordinator: AddItemsSheetViewControllerDelegate {
    
    func addItemsSheet(_ controller: AddItemsSheetViewController, didSelect destination: AddItemDestination) {
        switch destination {
        case .basicNeeds:
            let vc = factory.makeAddBasicNeedsSheet()
            navigation.pushViewController(vc, animated: true)
        case .measurement:
            let vc = factory.makeAddMeasurementSheet()
            navigation.pushViewController(vc, animated: true)
        case .medication:
            let vc = factory.makeAddMedication()
            navigation.pushViewController(vc, animated: true)
        case .routineActivity:
            let vc = factory.makeAddRoutineActivity()
            navigation.pushViewController(vc, animated: true)
        case .event:
            let vc = factory.makeAddEvent()
            navigation.pushViewController(vc, animated: true)
        case .symptom:
            let vc = factory.makeAddSymptom()
            navigation.pushViewController(vc, animated: true)
        case .close:
            navigation.presentingViewController?.dismiss(animated: true)
        }
    }
    
}
