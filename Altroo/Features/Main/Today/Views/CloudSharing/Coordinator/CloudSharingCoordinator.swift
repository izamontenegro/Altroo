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
    
    func presentSharingSheet() async {
        if !coreDataService.isShared(object: careRecipient) {
            do {
                try await createShareAndPresent(careRecipient)
            } catch {
                print("Share failed:", error)
                return
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
            let task = Task.detached {
                return try await self.coreDataService.stack.persistentContainer.share([careRecipient], to: nil)
            }
            
            let (_, share, _) = await task.value
            share[CKShare.SystemFieldKey.title] = careRecipient.personalData?.name ?? "Shared Item"
            
            let sharingController = UICloudSharingController(share: share, container: self.coreDataService.stack.ckContainer)
            configureAndPresent(sharingController)
            
        } catch {
            print("Share failed / timed out:", error)
            
            if let ckError = error as? CKError {
                DispatchQueue.main.async {
                    self.presentAlert(
                        title: "Erro do iCloud",
                        message: ckError.localizedDescription
                    )
                }
            } else {
                DispatchQueue.main.async {
                    self.presentAlert(
                        title: "Erro ao Compartilhar",
                        message: "Armazenamento do iCloud Cheio."
                    )
                }
            }
        }
    }
    
    private func presentAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        presentingViewController.present(alert, animated: true)
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
        // Handle failure to save the share
        print("Failed to save share: \(error.localizedDescription)")
        if let ckError = error as? CKError {
            DispatchQueue.main.async {
                self.presentAlert(
                    title: "Erro do iCloud",
                    message: ckError.localizedDescription
                )
            }
        } else {
            DispatchQueue.main.async {
                self.presentAlert(
                    title: "Erro ao Compartilhar",
                    message: "Não é possível compartilhar. Armazenamento do iCloud Cheio."
                )
            }
        }
    }
    
    func cloudSharingControllerDidSaveShare(_ csc: UICloudSharingController) {
        print("Saved the share")
        // Your CoreDataStack will automatically handle the shared context synchronization, so no extra code is needed here.
    }
    
    func cloudSharingControllerDidStopSharing(_ csc: UICloudSharingController) {
        guard coreDataService.isShared(object: careRecipient) else {
            print("Object not shared.")
            return
        }
        
        if !coreDataService.isOwner(object: careRecipient) {
            coreDataService.delete(careRecipient)
        }
    }
}
