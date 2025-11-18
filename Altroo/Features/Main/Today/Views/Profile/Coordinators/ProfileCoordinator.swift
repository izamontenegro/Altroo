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
    
    var onEndCare: (() -> Void)?
    
    init(navigation: UINavigationController, factory: AppFactory, associateFactory: AssociatePatientFactory) {
        self.factory = factory
        self.navigation = navigation
        self.associateFactory = associateFactory
    }
    
    func start() {
        let vc = factory.makeProfileViewController(delegate: self)
        navigation.pushViewController(vc, animated: true)
    }
}

extension ProfileCoordinator: ProfileViewControllerDelegate {
    
    func goToAllPatient() async {
        await MainActor.run {
            onEndCare?()
        }
    }
    
    func goToMedicalRecordViewController() {
        let editCoordinator = EditMedicalRecordCoordinator(
            navigation: navigation,
            factory: factory
        )
        add(child: editCoordinator)

        let vc = factory.makeMedicalRecordViewController(delegate: editCoordinator)
        navigation.pushViewController(vc, animated: true)

        editCoordinator.onFinish = { [weak self, weak editCoordinator] in
            guard let self, let editCoordinator else { return }
            self.remove(child: editCoordinator)
        }
    }
    
    func openShareCareRecipientSheet(_ careRecipient: CareRecipient) {
        guard let topViewController = navigation.topViewController else { return }
        
        let sharingCoordinator = CloudSharingCoordinator(
            presentingViewController: topViewController,
            careRecipient: careRecipient)
        
        self.cloudSharingCoordinator = sharingCoordinator
        
        Task {
            await sharingCoordinator.presentSharingSheet()
        }
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
