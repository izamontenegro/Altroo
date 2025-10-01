//
//  TodayCoordinator.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 22/09/25.
//

import UIKit

final class TodayCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    private let navigation: UINavigationController
    private let patientService: PatientService
    private let factory: AppFactory // <- NOVO

    var onRequestLogout: (() -> Void)?

    init(navigation: UINavigationController, patientService: PatientService, factory: AppFactory) {
        self.navigation = navigation
        self.patientService = patientService
        self.factory = factory
    }

    func start() {
        let vc = factory.makeToday(delegate: self)
        navigation.setViewControllers([vc], animated: false)
    }
    
    enum Destination { case profile }
    
    private func show(destination: Destination) {
        switch destination {
        case .profile:
            let vc = factory.makeProfile()
            navigation.pushViewController(vc, animated: true)
        }
    }
}

extension TodayCoordinator: TodayViewControllerDelegate {
    func GoToProfileView() {
        show(destination: .profile)
    }
}
