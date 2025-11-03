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
            
            NotificationCenter.default.addObserver(
                forName: .didFinishCloudKitSync,
                object: nil,
                queue: .main
            ) { _ in
                self.waitForSharedPatientAndStart()
                return
            }

        }
        
        let fetchRequest = NSFetchRequest<CareRecipient>(entityName: "CareRecipient")
        if let sharedPatients = try? CoreDataStack.shared.context.fetch(fetchRequest),
           let newPatient = sharedPatients.last {
            print(newPatient.personalData?.name)
        }
        
        proceedToUI()
//        if UserDefaults.standard.isFirstLaunch {
//            //            showOnboardingFlow()
//            showAllPatientsFlow()
//        } else if userService.fetchCurrentPatient() == nil {
//            showAllPatientsFlow()
//        } else {
//            showMainFlow()
//        }
    }
    
    private var cloudSyncObserver: NSObjectProtocol?

    func waitForSharedPatientAndStart() {
        cloudSyncObserver = NotificationCenter.default.addObserver(
            forName: .NSPersistentStoreRemoteChange,
            object: CoreDataStack.shared.persistentContainer.persistentStoreCoordinator,
            queue: .main
        ) { [weak self] _ in
            self?.tryLoadSharedPatient()
        }
        
        tryLoadSharedPatient()
    }

    private func tryLoadSharedPatient() {
        let fetchRequest = NSFetchRequest<CareRecipient>(entityName: "CareRecipient")

        if let sharedPatients = try? CoreDataStack.shared.context.fetch(fetchRequest),
           let newPatient = sharedPatients.last {

            print("Paciente sincronizado e disponível: \(newPatient)")
            userService.setCurrentPatient(newPatient)
            userService.addPatient(newPatient)

            if let observer = cloudSyncObserver {
                NotificationCenter.default.removeObserver(observer)
            }

            proceedToUI()
        } else {
            print("Paciente ainda não sincronizou, aguardando CloudKit…")
        }
    }
    
    func proceedToUI() {
        if UserDefaults.standard.isFirstLaunch {
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
