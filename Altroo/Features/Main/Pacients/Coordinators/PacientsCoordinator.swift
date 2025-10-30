//
//  PacientsCoordinator.swift
//  Altroo
//
//  Created by Marcelle Ribeiro Queiroz on 30/10/25.
//

import UIKit

final class PacientsCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigation: UINavigationController
    private let factory: AppFactory //This helps decouple screen creation from navigation logic.

    init(navigation: UINavigationController, factory: AppFactory) {
        self.factory = factory
        self.navigation = navigation
    }
    
    func start() {
        let vc = factory.makePacientsViewController()
        navigation.setViewControllers([vc], animated: false)
    }
}
