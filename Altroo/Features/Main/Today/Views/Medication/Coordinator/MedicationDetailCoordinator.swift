//
//  MedicationDetailCoordinator.swift
//  Altroo
//
//  Created by Raissa Parente on 03/10/25.
//

import UIKit

final class MedicationDetailCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    private let navigation: UINavigationController
    private let factory: AppFactory

    init(navigation: UINavigationController, factory: AppFactory) {
        self.factory = factory
        self.navigation = navigation
    }
    
    func start() {
        let vc = factory.makeMedicationDetailSheet(delegate: self)

        navigation.pushViewController(vc, animated: true)
    }
}

extension MedicationDetailCoordinator: MedicationDetailViewControllerDelegate {
    func didTapOutOfTimeButton() {
        let vc = factory.makeMedicationTimeSheet()
        vc.modalPresentationStyle = .pageSheet
        if let sheet = vc.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
        }
        navigation.pushViewController(vc, animated: true)
    }
}
