//
//  OnboardingCoordinator.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 22/09/25.
//

import UIKit

final class OnboardingCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    var navigation: UINavigationController
    private let factory: AppFactory

    var onFinish: (() -> Void)?

    init(navigation: UINavigationController, factory: AppFactory) {
        self.navigation = navigation
        self.factory = factory
    }

    func start() {
        let vc = factory.makeWelcomeOnboardingViewController(delegate: self)
        navigation.setViewControllers([vc], animated: false)
        navigation.setNavigationBarHidden(true, animated: false)
    }

}

extension OnboardingCoordinator: WelcomeOnboardingViewControllerDelegate {
    func goToAllPatient() {
        onFinish?()
    }
}
