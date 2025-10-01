//
//  SettingsCoordinator.swift
//  Altroo
//
//  Created by Layza Maria Rodrigues Carneiro on 25/09/25.
//

import UIKit

final class SettingsCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    private let navigation: UINavigationController
    private let patientService: PatientService
    private let factory: AppFactory

    init(navigation: UINavigationController, patientService: PatientService, factory: AppFactory) {
        self.factory = factory
        self.patientService = patientService
        self.navigation = navigation
    }
    
    func start() {
        let vc = factory.makeSettings()
        navigation.setViewControllers([vc], animated: false)
    }
    
    
}
