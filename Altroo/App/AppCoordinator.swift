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
    
    func start() {
        if userService.fetchUser() == nil {
            _ = userService.createUser(name: "\(UUID())", category: "Cuidador")
        }
        
        if receivedPatientViaShare {
            let fetchRequest = NSFetchRequest<CareRecipient>(entityName: "CareRecipient")
            if let sharedPatients = try? CoreDataStack.shared.context.fetch(fetchRequest),
               let newPatient = sharedPatients.last {
                print("Paciente recebido via share: \(newPatient)")
                userService.setCurrentPatient(newPatient)
                userService.addPatient(newPatient)
            } else {
                print("Nenhum CareRecipient encontrado no shared store ainda.")
            }
        }
        
        if UserDefaults.standard.isFirstLaunch {
            //            showOnboardingFlow()
            showAllPatientsFlow()
        } else if userService.fetchCurrentPatient() == nil {
            showAllPatientsFlow()
        } else {
            showMainFlow()
        }
    }
    
    private func showOnboardingFlow() {
        let onboardingCoordinator = OnboardingCoordinator(navigation: navigation,
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
        let mainCoordinator = MainCoordinator(navigation: navigation,
                                              factory: factory)
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
    
    private func showAllPatientsFlow() {
        let associatePatientCoordinator = AssociatePatientCoordinator(navigation: navigation,
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
