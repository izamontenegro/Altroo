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
    private let factory: AppFactory

    init(navigation: UINavigationController, patientService: PatientService, factory: AppFactory) {
        self.navigation = navigation
        self.patientService = patientService
        self.factory = factory
    }

    func start() {
        let vc = factory.makeAddItemSheet(delegate: self)
        navigation.setViewControllers([vc], animated: false)
    }

    enum Destination { case nextStep, end }
    
    private func show(destination: Destination) {
        switch destination {
        case .nextStep:
            let vc = factory.makeAddMedicine()
            navigation.pushViewController(vc, animated: true)
            
        case .end:
            navigation.presentingViewController?.dismiss(animated: true)
        }
    }
}

extension AddItemCoordinator: AddItemsSheetViewControllerDelegate {
    func AddItemsSheetGoToNext() {
        show(destination: .nextStep)
    }
    
    func AddItemsSheetGoBack() {
        show(destination: .end)
    }
}
