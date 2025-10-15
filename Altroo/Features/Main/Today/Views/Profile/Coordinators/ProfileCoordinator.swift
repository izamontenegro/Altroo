//
//  ProfileCoordinator.swift
//  Altroo
//
//  Created by Raissa Parente on 02/10/25.
//
import UIKit
import CloudKit

final class ProfileCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigation: UINavigationController
    private let factory: AppFactory
    
    private var cloudSharingCoordinator: CloudSharingCoordinator?
    
    init(navigation: UINavigationController, factory: AppFactory) {
        self.factory = factory
        self.navigation = navigation
    }
    
    func start() {
        let vc = factory.makeProfileViewController(delegate: self)
        navigation.pushViewController(vc, animated: false)
    }
}

extension ProfileCoordinator: ProfileViewControllerDelegate {
    
    func goToMedicalRecordViewController() {
        let vc = factory.makeMedicalRecordViewController()
        
        navigation.pushViewController(vc, animated: true)
    }
    
    func openShareCareRecipientSheet(_ careRecipient: CareRecipient) {
        guard let topViewController = navigation.topViewController else { return }
        
        let sharingCoordinator = CloudSharingCoordinator(
            presentingViewController: topViewController,
            careRecipient: careRecipient)
        
        self.cloudSharingCoordinator = sharingCoordinator
        
        sharingCoordinator.presentSharingSheet()
    }
    
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
