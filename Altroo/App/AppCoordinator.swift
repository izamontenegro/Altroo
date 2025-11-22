//
//  AppCoordinator.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 22/09/25.
//

import UIKit
import CoreData

final class AppCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    weak var parentCoordinator: AppCoordinator?
    var navigation: UINavigationController
    private let factory: AppFactory
    
    let dependencies = AppDependencies()
    private var userService: UserServiceProtocol
    
    var receivedPatientViaShare: Bool = false
    
    init(rootNavigation: UINavigationController) {
        self.navigation = rootNavigation
        self.userService = UserServiceSession(context: dependencies.coreDataService.stack.context)
        self.factory = DefaultAppFactory(dependencies: dependencies)
        rootNavigation.setNavigationBarHidden(true, animated: false)
    }
    
    
    @MainActor
    func start() async {

        if !UserDefaults.standard.onboardingCompleted {
            if userService.fetchUser() == nil {
                _ = userService.createUser(name: "", category: "Cuidador")
            }
            showOnboardingFlow(receivedPatientViaShare: receivedPatientViaShare)
        } else if userService.fetchCurrentPatient() == nil {
            showAllPatientsFlow(receivedPatientViaShare: receivedPatientViaShare)
        } else {
            showMainFlow()
        }
    }
    
    @MainActor
    private func waitForSharedPatientSync(timeout: Int) async {
        for _ in 1...timeout {
            try? await Task.sleep(nanoseconds: 1_000_000_000)
        }
        return
    }

    private func showOnboardingFlow(receivedPatientViaShare: Bool = false) {
        let onboardingCoordinator = OnboardingCoordinator(navigation: navigation,
                                                          factory: factory)
        onboardingCoordinator.onFinish = { [weak self, weak onboardingCoordinator] in
            guard let self, let onboardingCoordinator else { return }
            self.remove(child: onboardingCoordinator)
            self.showAllPatientsFlow(receivedPatientViaShare: receivedPatientViaShare)
        }
        add(child: onboardingCoordinator)
        onboardingCoordinator.start()
    }
    
    private func showMainFlow() {
        let mainCoordinator = MainCoordinator(navigation: navigation,
                                              factory: factory)
        mainCoordinator.parentCoordinator = self
        mainCoordinator.onLogout = { [weak self, weak mainCoordinator] in
            guard let self, let mainCoordinator else { return }
            self.remove(child: mainCoordinator)
            self.userService.removeCurrentPatient()
            self.navigation.viewControllers = []
            self.showMainFlow()
        }
        add(child: mainCoordinator)
        mainCoordinator.start()
    }
    
    private func showAllPatientsFlow(receivedPatientViaShare: Bool = false) {
        let associatePatientCoordinator = AssociatePatientCoordinator(navigation: navigation,
                                                                      factory: factory)
        associatePatientCoordinator.onFinish = { [weak self, weak associatePatientCoordinator] in
            guard let self, let associatePatientCoordinator else { return }
            self.remove(child: associatePatientCoordinator)
            self.showMainFlow()
        }
        add(child: associatePatientCoordinator)
        
        if receivedPatientViaShare {
            associatePatientCoordinator.receivePatient()
        } else {
            associatePatientCoordinator.start()
        }
    }
    
    @MainActor
    func restartToAllPatients() {
        childCoordinators.removeAll()
        userService.removeCurrentPatient()

        UIView.transition(with: navigation.view,
                          duration: 0.3,
                          options: [.transitionCrossDissolve],
                          animations: {
            self.navigation.view.alpha = 0
        }) { _ in

            self.navigation.viewControllers = []
            self.showAllPatientsFlow()

            UIView.transition(with: self.navigation.view,
                              duration: 0.3,
                              options: [.transitionCrossDissolve],
                              animations: {
                self.navigation.view.alpha = 1
            })
        }
    }
}

extension AppCoordinator: ShiftFormsViewControllerDelegate {
    func shiftFormsDidFinish() {
        
    }
}
