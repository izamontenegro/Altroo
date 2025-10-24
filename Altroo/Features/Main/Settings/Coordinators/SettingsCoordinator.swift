//
//  SettingsCoordinator.swift
//  Altroo
//
//  Created by Layza Maria Rodrigues Carneiro on 25/09/25.
//

import UIKit



final class SettingsCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigation: UINavigationController
    private let factory: AppFactory

    init(navigation: UINavigationController, factory: AppFactory) {
        self.factory = factory
        self.navigation = navigation
    }
    
    func start() {
        let vc = factory.makeSettingsViewController(delegate: self)
        navigation.setViewControllers([vc], animated: false)
    }
}

extension SettingsCoordinator: SettingsViewControllerDelegate {
    func goToUserProfile() {
        let vc = factory.makeUserProfileViewController()
        navigation.pushViewController(vc, animated: true)
    }
    
    func goToPrivacySecurity() {
        let vc = factory.makePrivacySecurityViewController()
        navigation.pushViewController(vc, animated: true)
    }
    
    func goToDevelopers() {
        let vc = factory.makeDevelopersViewController()
        navigation.pushViewController(vc, animated: true)
    }
}
