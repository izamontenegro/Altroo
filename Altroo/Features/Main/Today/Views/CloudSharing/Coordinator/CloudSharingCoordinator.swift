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
        if !coreDataService.isShared(object: careRecipient) {
            Task {
                await createShareAndPresent(careRecipient)
            }
        }
        
        if let share = self.coreDataService.getShare(self.careRecipient) {
            let sharingController = UICloudSharingController(
                share: share,
                container: self.coreDataService.stack.ckContainer
            )
            
            self.configureAndPresent(sharingController)
        }
    }
    
    func createShareAndPresent(_ careRecipient: CareRecipient, timeoutSeconds: Int = 15) async {
        do {
            let result = try await withThrowingTaskGroup(of: (Set<NSManagedObjectID>, CKShare, CKContainer).self) { group in
                group.addTask {
                    let res = try await self.coreDataService.stack.persistentContainer.share([careRecipient], to: nil)
                    return res
                }
                
                group.addTask {
                    try await Task.sleep(nanoseconds: UInt64(timeoutSeconds) * 1_000_000_000)
                    throw NSError(domain: "DebugShare", code: 999, userInfo: [NSLocalizedDescriptionKey: "share() timeout"])
                }
                
                let result = try await group.next()!
                group.cancelAll()
                return result
            }
            
            let (_, share, _) = result
            share[CKShare.SystemFieldKey.title] = careRecipient.personalData?.name ?? "Shared Item"
            share.publicPermission = .readWrite
            
            let sharingController = UICloudSharingController(share: share, container: self.coreDataService.stack.ckContainer)
            configureAndPresent(sharingController)
            
        } catch {
            print("Share failed / timed out:", error)
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
            coreDataService.delete(careRecipient)
        }
    }
}
