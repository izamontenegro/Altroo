//
//  EditMedicalRecordCoordinator.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 28/10/25.
//

import UIKit

final class EditMedicalRecordCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigation: UINavigationController
    private let factory: EditMedicalRecordFactory

    var onFinish: (() -> Void)?

    init(navigation: UINavigationController, factory: EditMedicalRecordFactory) {
        self.navigation = navigation
        self.factory = factory
    }

    func start() {
        let vc = factory.makeEditPersonalDataViewController(delegate: self)
        navigation.pushViewController(vc, animated: true)
    }

    enum Destination { case personalData, healthProblems, physicalState, mentalState, personalCare }

    private func show(_ destination: Destination) {
        switch destination {
        case .personalData:
            let vc = factory.makeEditPersonalDataViewController(delegate: self)
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .pageSheet

            if let sheet = nav.sheetPresentationController {
                sheet.detents = [
                    .custom(identifier: .init("almostFull")) { context in
                        context.maximumDetentValue * 0.9
                    }
                ]
                sheet.prefersGrabberVisible = true
            }

            navigation.setNavigationBarHidden(true, animated: true)
            navigation.present(nav, animated: true)
            
        case .healthProblems:
            let vc = factory.makeEditPersonalDataViewController(delegate: self)
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .pageSheet

            if let sheet = nav.sheetPresentationController {
                sheet.detents = [
                    .custom(identifier: .init("almostFull")) { context in
                        context.maximumDetentValue * 0.9
                    }
                ]
                sheet.prefersGrabberVisible = true
            }

            navigation.setNavigationBarHidden(true, animated: true)
            navigation.present(nav, animated: true)
            
        case .physicalState:
            let vc = factory.makeEditPersonalDataViewController(delegate: self)
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .pageSheet

            if let sheet = nav.sheetPresentationController {
                sheet.detents = [
                    .custom(identifier: .init("almostFull")) { context in
                        context.maximumDetentValue * 0.9
                    }
                ]
                sheet.prefersGrabberVisible = true
            }

            navigation.setNavigationBarHidden(true, animated: true)
            navigation.present(nav, animated: true)
            
        case .mentalState:
            let vc = factory.makeEditPersonalDataViewController(delegate: self)
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .pageSheet

            if let sheet = nav.sheetPresentationController {
                sheet.detents = [
                    .custom(identifier: .init("almostFull")) { context in
                        context.maximumDetentValue * 0.9
                    }
                ]
                sheet.prefersGrabberVisible = true
            }

            navigation.setNavigationBarHidden(true, animated: true)
            navigation.present(nav, animated: true)
            
        case .personalCare:
            let vc = factory.makeEditPersonalDataViewController(delegate: self)
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .pageSheet

            if let sheet = nav.sheetPresentationController {
                sheet.detents = [
                    .custom(identifier: .init("almostFull")) { context in
                        context.maximumDetentValue * 0.9
                    }
                ]
                sheet.prefersGrabberVisible = true
            }

            navigation.setNavigationBarHidden(true, animated: true)
            navigation.present(nav, animated: true)
            
        }
    }
}

extension EditMedicalRecordCoordinator: EditMedicalRecordViewControllerDelegate {
    func goToPersonalData() {
        show(.personalData)
    }
    
    func goToMentalState() {
        show(.mentalState)
    }
    
    func goToPersonalCare() {
        show(.personalCare)
    }
    
    func goToPhysicalState() {
        show(.physicalState)
    }
    
    func goToHealthProblems() {
        show(.healthProblems)
    }
}
