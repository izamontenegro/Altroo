//
//  OnboardingCoordinator.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 22/09/25.
//

import UIKit

final class OnboardingCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    private let navigation: UINavigationController
    private let patientService: PatientService
    private let factory: AppFactory

    var onFinish: (() -> Void)?

    init(navigation: UINavigationController, patientService: PatientService, factory: AppFactory) {
        self.navigation = navigation
        self.patientService = patientService
        self.factory = factory
    }

    func start() {
        let vc = factory.makeWelcomeViewController(delegate: self)
        navigation.setViewControllers([vc], animated: false)
        navigation.setNavigationBarHidden(true, animated: false)
    }

}

extension OnboardingCoordinator: WelcomeViewControllerDelegate {
    func goToAllPatient() {
        onFinish?()
    }
}
