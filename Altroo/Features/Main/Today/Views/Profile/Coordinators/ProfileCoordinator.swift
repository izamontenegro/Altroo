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
    
    private let associateFactory: AssociatePatientFactory

    var navigation: UINavigationController
    private let factory: AppFactory
    
    private var cloudSharingCoordinator: CloudSharingCoordinator?
    
    init(navigation: UINavigationController, factory: AppFactory, associateFactory: AssociatePatientFactory) {
        self.factory = factory
        self.navigation = navigation
        self.associateFactory = associateFactory
    }
    
    func start() {
        let vc = factory.makeProfileViewController(delegate: self)
        navigation.pushViewController(vc, animated: false)
    }
}

extension ProfileCoordinator: ProfileViewControllerDelegate {
    func careRecipientProfileWantsChangeAssociate(_ controller: UIViewController) {
            controller.dismiss(animated: true) { [weak self] in
                guard let self else { return }
                let associate = AssociatePatientCoordinator(
                    navigation: self.navigation,
                    factory: self.associateFactory
                )
                self.add(child: associate)
                associate.onFinish = { [weak self, weak associate] in
                    guard let self, let associate else { return }
                    self.remove(child: associate)
                }
                associate.start()
            }
        
    }
    
    
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
    

    func openChangeCareRecipientSheet() {
        let vc = factory.makeChangeCareRecipientViewController(delegate: self)
        vc.modalPresentationStyle = .pageSheet
        if let sheet = vc.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
        }
        navigation.present(vc, animated: true)
    }
}

extension ProfileCoordinator {
    func goToAssociatePatientViewController() {
        let associate = AssociatePatientCoordinator(
            navigation: navigation,
            factory: associateFactory
        )
        childCoordinators.append(associate)

        associate.onFinish = { [weak self, weak associate] in
            guard let self, let associate else { return }
            self.childCoordinators.removeAll { $0 === associate }
            // self.navigation.popToViewController(<profileVC>, animated: true)
        }

        associate.start()
    }
}

extension ProfileCoordinator: ChangeCareRecipientViewControllerDelegate {
    func changeCareRecipientWantsStartAssociate(_ controller: UIViewController) {
        controller.dismiss(animated: true) { [weak self] in
            guard let self else { return }
            let associate = AssociatePatientCoordinator(
                navigation: self.navigation,
                factory: self.associateFactory
            )
            self.add(child: associate)
            associate.onFinish = { [weak self, weak associate] in
                guard let self, let associate else { return }
                self.remove(child: associate)
            }
            associate.start()
        }
    }
}
