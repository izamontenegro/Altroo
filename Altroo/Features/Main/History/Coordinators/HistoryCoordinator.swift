//
//  HistoryCoordinator.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 22/09/25.
//

import UIKit

final class HistoryCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    var navigation: UINavigationController
    private let factory: AppFactory
    
    init(navigation: UINavigationController, factory: AppFactory) {
        self.navigation = navigation; self.factory = factory
    }
    
    func start() {
        let vc = factory.makeHistoryViewController(delegate: self)
        navigation.setViewControllers([vc], animated: false)
    }
}

extension HistoryCoordinator: HistoryViewControllerDelegate {
    func openDetailSheet(_ controller: HistoryViewController, item: HistoryItem) {
        let vc = factory.makeSeeHistoryDetailSheet()
        vc.modalPresentationStyle = .pageSheet

        if let sheet = vc.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
        }
        navigation.present(vc, animated: true)
    }
}
