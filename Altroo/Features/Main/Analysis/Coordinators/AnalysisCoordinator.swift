//
//  AnalysisCoordinator.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 22/09/25.
//

import UIKit

final class AnalysisCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    private let navigation: UINavigationController
    private let factory: AppFactory
    init(navigation: UINavigationController, factory: AppFactory) {
        self.navigation = navigation; self.factory = factory
    }
    func start() {
        let vc = factory.makeAnalysisViewController()
        navigation.setViewControllers([vc], animated: false)
    }
}
