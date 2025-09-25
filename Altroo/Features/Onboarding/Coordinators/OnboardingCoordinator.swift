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
        let vc = factory.makeWelcome(delegate: self)
        navigation.setViewControllers([vc], animated: false)
        navigation.setNavigationBarHidden(true, animated: false)
    }
    
    enum Destination { case patientForms, comorbiditiesForms }
    
    private func show(destination: Destination) {
        switch destination {
        case .patientForms:
            let vc = factory.makePatientForm(delegate: self)
            navigation.pushViewController(vc, animated: true)
            
        case .comorbiditiesForms:
            let vc = factory.makeComorbiditiesForms(delegate: self)
            navigation.pushViewController(vc, animated: true)
        }
    }
}

extension OnboardingCoordinator: WelcomeViewControllerDelegate {
    func goToPatientForms() {
        show(destination: .patientForms)
    }
    
    func goToComorbiditiesForms() {
        show(destination: .comorbiditiesForms)
    }
}

extension OnboardingCoordinator: ComorbiditiesFormsViewControllerDelegate {
    func comorbiditiesFormsDidFinish() {
        onFinish?()
    }
}
