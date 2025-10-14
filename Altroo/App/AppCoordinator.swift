//
//  AppCoordinator.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 22/09/25.
//

import UIKit

final class AppCoordinator: Coordinator {

    var childCoordinators: [Coordinator] = []
    private let rootNavigation: UINavigationController
    private let factory: AppFactory
    
    let dependencies = AppDependencies()
    private var userService: UserServiceProtocol

    init(rootNavigation: UINavigationController) {
        self.rootNavigation = rootNavigation
        self.factory = DefaultAppFactory(dependencies: dependencies)
        self.userService = UserServiceSession(context: dependencies.coreDataService.stack.context)
        rootNavigation.setNavigationBarHidden(true, animated: false)
    }

    func start() {
        if UserDefaults.standard.isFirstLaunch {
            showOnboardingFlow()
        } else if userService.fetchCurrentPatient() == nil {
            showAllPatientsFlow()
        } else {
            showMainFlow()
        }
    }

    private func showOnboardingFlow() {
        let onboardingCoordinator = OnboardingCoordinator(navigation: rootNavigation,
                                                          factory: factory)
        onboardingCoordinator.onFinish = { [weak self, weak onboardingCoordinator] in
            guard let self, let onboardingCoordinator else { return }
            self.remove(child: onboardingCoordinator)
            self.showAllPatientsFlow()
        }
        add(child: onboardingCoordinator)
        onboardingCoordinator.start()
    }

    private func showMainFlow() {
        let mainCoordinator = MainCoordinator(navigation: rootNavigation,
                                              factory: factory)
        mainCoordinator.onLogout = { [weak self, weak mainCoordinator] in
            guard let self, let mainCoordinator else { return }
            self.remove(child: mainCoordinator)
            self.userService.removeCurrentPatient()
            self.rootNavigation.viewControllers = []
            self.showMainFlow()
        }
        add(child: mainCoordinator)
        mainCoordinator.start()
    }

    private func showAllPatientsFlow() {
        let associatePatientCoordinator = AssociatePatientCoordinator(navigation: rootNavigation,
                                              factory: factory)
        associatePatientCoordinator.onFinish = { [weak self, weak associatePatientCoordinator] in
            guard let self, let associatePatientCoordinator else { return }
            self.remove(child: associatePatientCoordinator)
            self.showMainFlow()
        }
        add(child: associatePatientCoordinator)
        associatePatientCoordinator.start()
    }
}
