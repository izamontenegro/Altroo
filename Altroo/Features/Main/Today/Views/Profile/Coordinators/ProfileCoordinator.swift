//
//  ProfileCoordinator.swift
//  Altroo
//
//  Created by Raissa Parente on 02/10/25.
//
import UIKit

final class ProfileCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    private let navigation: UINavigationController
    private let patientService: PatientService
    private let factory: AppFactory

    init(navigation: UINavigationController, patientService: PatientService, factory: AppFactory) {
        self.factory = factory
        self.patientService = patientService
        self.navigation = navigation
    }
    
    func start() {
        let vc = factory.makeProfileViewController(delegate: self)
        navigation.pushViewController(vc, animated: false)
    }
}

extension ProfileCoordinator: ProfileViewControllerDelegate {
    func openChangeCaregiversSheet() {
        let vc = factory.makeChangeCaregiverViewController()
        vc.modalPresentationStyle = .pageSheet
        
        if let sheet = vc.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
        }
        navigation.present(vc, animated: true)
    }
    
    func openEditCaregiversSheet() {
        let vc = factory.makeEditCaregiverViewController()
        vc.modalPresentationStyle = .pageSheet
        
        if let sheet = vc.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
        }
        navigation.present(vc, animated: true)
    }
}
