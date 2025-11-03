////
////  CloudSharingCoordinator.swift
////  Altroo
////
////  Created by Raissa Parente on 03/10/25.
////
//
//import CloudKit
//import UIKit
//import CoreData
//
//final class CloudSharingCoordinator: NSObject, UICloudSharingControllerDelegate {
//    private let coreDataService: CoreDataService
//    private let presentingViewController: UIViewController
//    private let careRecipient: CareRecipient
//    
//    init(presentingViewController: UIViewController, careRecipient: CareRecipient, coreDataService: CoreDataService = CoreDataService()) {
//        self.presentingViewController = presentingViewController
//        self.careRecipient = careRecipient
//        self.coreDataService = coreDataService
//        super.init()
//    }
//    
//    func presentSharingSheet() {
//        if !coreDataService.isShared(object: careRecipient) {
//            Task {
//                await createShareAndPresent(careRecipient)
//            }
//        }
//        
//        if let share = self.coreDataService.getShare(self.careRecipient) {
//            let sharingController = UICloudSharingController(
//                share: share,
//                container: self.coreDataService.stack.ckContainer
//            )
//            
//            self.configureAndPresent(sharingController)
//        }
//    }
//    
//    func createShareAndPresent(_ careRecipient: CareRecipient, timeoutSeconds: Int = 15) async {
//        do {
//            let result = try await withThrowingTaskGroup(of: (Set<NSManagedObjectID>, CKShare, CKContainer).self) { group in
//                group.addTask {
//                    let res = try await self.coreDataService.stack.persistentContainer.share([careRecipient], to: nil)
//                    return res
//                }
//                
//                group.addTask {
//                    try await Task.sleep(nanoseconds: UInt64(timeoutSeconds) * 1_000_000_000)
//                    throw NSError(domain: "DebugShare", code: 999, userInfo: [NSLocalizedDescriptionKey: "share() timeout"])
//                }
//                
//                let result = try await group.next()!
//                group.cancelAll()
//                return result
//            }
//            
//            let (_, share, _) = result
//            share[CKShare.SystemFieldKey.title] = careRecipient.personalData?.name ?? "Shared Item"
//            
//            let sharingController = UICloudSharingController(share: share, container: self.coreDataService.stack.ckContainer)
//            configureAndPresent(sharingController)
//            
//        } catch {
//            print("Share failed / timed out:", error)
//        }
//    }
//    
//    private func configureAndPresent(_ controller: UICloudSharingController) {
//        controller.delegate = self
//        controller.modalPresentationStyle = .formSheet
//        presentingViewController.present(controller, animated: true, completion: nil)
//    }
//    
//    // MARK: - UICloudSharingControllerDelegate
//    
//    func itemTitle(for csc: UICloudSharingController) -> String? {
//        // Use the managedObject to get the title
//        return careRecipient.personalData?.name
//    }
//    
//    func cloudSharingController(_ csc: UICloudSharingController, failedToSaveShareWithError error: Error) {
//        print("Failed to save share: \(error.localizedDescription)")
//        // Handle failure to save the share
//    }
//    
//    func cloudSharingControllerDidSaveShare(_ csc: UICloudSharingController) {
//        print("Saved the share")
//        // Your CoreDataStack will automatically handle the shared context synchronization, so no extra code is needed here.
//    }
//    
//    func cloudSharingControllerDidStopSharing(_ csc: UICloudSharingController) {
//        if !coreDataService.isOwner(object: careRecipient) {
//            coreDataService.delete(careRecipient)
//        }
//    }
//    
//}

import CloudKit
import UIKit
import CoreData

final class CloudSharingCoordinator: NSObject, UICloudSharingControllerDelegate {

    private let coreDataService: CoreDataService
    private let presentingViewController: UIViewController
    private let careRecipient: CareRecipient

    init(
        presentingViewController: UIViewController,
        careRecipient: CareRecipient,
        coreDataService: CoreDataService = CoreDataService()
    ) {
        self.presentingViewController = presentingViewController
        self.careRecipient = careRecipient
        self.coreDataService = coreDataService
        super.init()
    }

    // MARK: - Apresentar Sharing Sheet
    func presentSharingSheet() {
        Task {
            // Se ainda não está compartilhado, cria share no shared store
            if !coreDataService.isShared(object: careRecipient) {
                await createShareInSharedStore(for: careRecipient)
            }

            // Recupera o share criado para apresentar o UICloudSharingController
            guard let share = coreDataService.getShare(careRecipient) else { return }
            let sharingController = UICloudSharingController(
                share: share,
                container: coreDataService.stack.ckContainer
            )
            configureAndPresent(sharingController)
        }
    }

    // MARK: - Criar share no Shared Store
    private func createShareInSharedStore(for careRecipient: CareRecipient, timeoutSeconds: Int = 15) async {

        do {
            // Obter contexto do shared store
            let container = coreDataService.stack.persistentContainer
            let sharedStore = coreDataService.stack.sharedPersistentStore

            let sharedContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
            sharedContext.persistentStoreCoordinator = container.persistentStoreCoordinator
            sharedContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy

            // Criar objeto no shared store
            let sharedCareRecipient = CareRecipient(context: sharedContext)

            // Copiar personalData
            if let pd = careRecipient.personalData {
                let sharedPD = PersonalData(context: sharedContext)
                sharedPD.name = pd.name
                sharedPD.dateOfBirth = pd.dateOfBirth
                sharedPD.gender = pd.gender
                sharedPD.height = pd.height
                sharedPD.weight = pd.weight
                sharedPD.address = pd.address
                sharedCareRecipient.personalData = sharedPD

                // Copiar contatos
                for contact in pd.contacts ?? [] {
                    let sharedContact = Contact(context: sharedContext)
//                    sharedContact.name = contact.name
//                    sharedContact.contactMethod = contact.contactMethod
                    sharedPD.addToContacts(sharedContact)
                }
            }

            try sharedContext.save()

            try await withThrowingTaskGroup(of: (CKShare, CKContainer).self) { group in
                group.addTask {
                    let (records, share, container) = try await container.share(
                        [sharedCareRecipient],
                        to: nil
                    )
                    return (share, container)
                }

                group.addTask {
                    try await Task.sleep(nanoseconds: UInt64(timeoutSeconds) * 1_000_000_000)
                    throw NSError(domain: "CloudSharingCoordinator", code: 999, userInfo: [NSLocalizedDescriptionKey: "Share timeout"])
                }

                let (share, _) = try await group.next()!
                group.cancelAll()

                // Configurar título do share
                share[CKShare.SystemFieldKey.title] = sharedCareRecipient.personalData?.name ?? "Shared Item"

                // Salvar Core Data
                try sharedContext.save()

                // Salvar referência do share no Core Data
                coreDataService.save()

                // Apresentar sharing controller
                let sharingController = UICloudSharingController(share: share, container: coreDataService.stack.ckContainer)
                configureAndPresent(sharingController)
            }
        } catch {
            print("Failed to create share: \(error)")
        }
    }

    // MARK: - Configurar e apresentar
    private func configureAndPresent(_ controller: UICloudSharingController) {
        controller.delegate = self
        controller.modalPresentationStyle = .formSheet
        presentingViewController.present(controller, animated: true)
    }

    // MARK: - UICloudSharingControllerDelegate
    func itemTitle(for csc: UICloudSharingController) -> String? {
        return careRecipient.personalData?.name
    }

    func cloudSharingController(_ csc: UICloudSharingController, failedToSaveShareWithError error: Error) {
        print("Failed to save share: \(error.localizedDescription)")
    }

    func cloudSharingControllerDidSaveShare(_ csc: UICloudSharingController) {
        print("Share saved successfully")
    }

    func cloudSharingControllerDidStopSharing(_ csc: UICloudSharingController) {
        if coreDataService.isOwner(object: careRecipient) {
            // Owner apenas limpa a referência do share
//            coreDataService.save()
        } else {
            // Participante remove o objeto local
            coreDataService.delete(careRecipient)
        }
    }
}
