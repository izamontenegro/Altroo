//
//  LoadingCoordinator.swift
//  Altroo
//
//  Created by Marcelle Ribeiro Queiroz on 03/11/25.
//

import UIKit

final class LoadingCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    var navigation: UINavigationController
    private let factory: AppFactory
    
    var onFinish: (() -> Void)?

    init(navigation: UINavigationController, factory: AppFactory) {
        self.navigation = navigation; self.factory = factory
    }
    
    func start() {
        let vc = factory.makeLoadingViewController(delegate: self)
        navigation.pushViewController(vc, animated: true)
    }
}

// MARK: - LoadingViewControllerDelegate
extension LoadingCoordinator: LoadingViewControllerDelegate {
    func loadingDidFinish() {
        onFinish?()
    }
}
