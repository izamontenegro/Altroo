//
//  CloudSharingCoordinator.swift
//  Altroo
//
//  Created by Raissa Parente on 03/10/25.
//

import CloudKit
import UIKit
import CoreData

final class CloudSharingCoordinator: NSObject, UICloudSharingControllerDelegate {
    private let coreDataService: CoreDataService
    private let presentingViewController: UIViewController
    private let careRecipient: CareRecipient
    
    init(presentingViewController: UIViewController, careRecipient: CareRecipient, coreDataService: CoreDataService = CoreDataService()) {
        self.presentingViewController = presentingViewController
        self.careRecipient = careRecipient
        self.coreDataService = coreDataService
        super.init()
    }
    
    func presentSharingSheet() {
        CoreDataStack.shared.cloudKitReady { [self] in
            
            Task {
                if let share = try coreDataService.getShare(careRecipient) {
                    // if a share already exists
                    let sharingController = UICloudSharingController(share: share, container: coreDataService.stack.ckContainer)
                    configureAndPresent(sharingController)
                } else {
                    // if a new share needs to be created
                    await createShareAndPresent()
                }
            }
        }
    }
    
    private func createShareAndPresent() async {
        do {
            let (_, share, container) = try await coreDataService.stack.persistentContainer.share([careRecipient as NSManagedObject], to: nil)
            
            share[CKShare.SystemFieldKey.title] = careRecipient.personalData?.name ?? "Shared Item"
            
            let sharingController = UICloudSharingController(share: share, container: container)
            configureAndPresent(sharingController)
            
        } catch {
            print("Failed to create share: \(error.localizedDescription)")
            if let ckError = error as? CKError {
                print("CloudKit error: \(ckError.errorCode), \(ckError.localizedDescription)")
            }
        }
    }
    
    private func configureAndPresent(_ controller: UICloudSharingController) {
        controller.delegate = self
        controller.modalPresentationStyle = .formSheet
        presentingViewController.present(controller, animated: true, completion: nil)
    }
    
    // MARK: - UICloudSharingControllerDelegate
    
    func itemTitle(for csc: UICloudSharingController) -> String? {
        // Use the managedObject to get the title
        return careRecipient.personalData?.name
    }
    
    func cloudSharingController(_ csc: UICloudSharingController, failedToSaveShareWithError error: Error) {
        print("Failed to save share: \(error.localizedDescription)")
        // Handle failure to save the share
    }
    
    func cloudSharingControllerDidSaveShare(_ csc: UICloudSharingController) {
        print("Saved the share")
        // Your CoreDataStack will automatically handle the shared context synchronization, so no extra code is needed here.
    }
    
    func cloudSharingControllerDidStopSharing(_ csc: UICloudSharingController) {
        if !coreDataService.isOwner(object: careRecipient) {
            coreDataService.deleteCareRecipient(careRecipient)
        }
    }
}
