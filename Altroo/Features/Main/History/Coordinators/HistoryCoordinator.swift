//
//  HistoryCoordinator.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 22/09/25.
//
import UIKit

final class HistoryCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    private let navigation: UINavigationController
    private let patientService: PatientService
    private let factory: AppFactory
    init(navigation: UINavigationController, patientService: PatientService, factory: AppFactory) {
        self.navigation = navigation; self.patientService = patientService; self.factory = factory
    }
    func start() {
        let vc = factory.makeHistoryViewController(delegate: self)
        navigation.setViewControllers([vc], animated: false)
    }
}

extension HistoryCoordinator: HistoryViewControllerDelegate {
    func openDetailSheet(_ controller: HistoryViewController) {
        let vc = factory.makeSeeHistoryDetailSheet()
        vc.modalPresentationStyle = .pageSheet
        
        if let sheet = vc.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
        }
        navigation.present(vc, animated: true)
    }
}
