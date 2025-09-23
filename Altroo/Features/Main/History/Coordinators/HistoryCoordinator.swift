//
//  VisualizarHistoricoCoordinator.swift
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
        let vc = factory.makeHistory()
        navigation.setViewControllers([vc], animated: false)
    }
}
