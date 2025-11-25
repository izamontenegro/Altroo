//
//  SceneDelegate.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 18/09/25.
//

import UIKit
import CloudKit
import CoreData
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    var appCoordinator: AppCoordinator?
    
    // MARK: - Shared Sync State
    private var waitingForSharedSync = false
    private var sharedPollingTask: Task<Void, Never>?
    private var initialSharedCount = 0
    private var loadingVC: UIViewController?
    private var loadingStartTime: Date?

    // MARK: - UI Helpers
    func showLoadingScreen() {
        Task { @MainActor in
            guard let window = window else { return }

            let loadingView = LoadingReceivePatientView(
                logo: Image("loading_receive"),
                isSyncing: waitingForSharedSync
            )

            let loading = UIHostingController(rootView: loadingView)
            loading.modalPresentationStyle = .overFullScreen
            loading.modalTransitionStyle = .crossDissolve
            loading.view.backgroundColor = .clear

            window.rootViewController?.present(loading, animated: true)

            loadingVC = loading
            loadingStartTime = Date()
        }
    }

    
    func hideLoadingScreen() {
        Task { @MainActor in
            loadingVC?.dismiss(animated: true)
            loadingVC = nil
        }
    }
    
    func hideLoadingScreenAfterMinimumDelay() {
        guard let start = loadingStartTime else {
            hideLoadingScreen()
            return
        }

        let elapsed = Date().timeIntervalSince(start)
        let minDelay: TimeInterval = 3.0

        if elapsed >= minDelay {
            hideLoadingScreen()
        } else {
            let remaining = minDelay - elapsed
            DispatchQueue.main.asyncAfter(deadline: .now() + remaining) {
                self.hideLoadingScreen()
            }
        }
    }

    // MARK: - Scene Lifecycle
    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = scene as? UIWindowScene else { return }
        
        let window = UIWindow(windowScene: windowScene)
        let navigation = UINavigationController()
        let appCoordinator = AppCoordinator(rootNavigation: navigation)
                
        window.rootViewController = navigation
        window.makeKeyAndVisible()
        window.overrideUserInterfaceStyle = .light
        
        self.window = window
        self.appCoordinator = appCoordinator
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(sharedStoreDidSync),
            name: .sharedStoreDidSync,
            object: nil
        )
        
        Task {
            await appCoordinator.start()
        }
    }
    
    func windowScene(_ windowScene: UIWindowScene,
                     userDidAcceptCloudKitShareWith metadata: CKShare.Metadata) {

        guard let sharedUUID = metadata.share[CKShare.SystemFieldKey.title] as? String else {
            return
        }
        
        if let existingPatient = findPatientForShareTitle(sharedUUID) {
//            showLoadingScreen()

            Task { @MainActor in
                hideLoadingScreenAfterMinimumDelay()
                appCoordinator?.receivedPatientViaShare = true
                appCoordinator?.sharedReceivedPatient = existingPatient
                await appCoordinator?.start()
            }

            return
        }

        initialSharedCount = countSharedPatients()
        let shareStore = CoreDataStack.shared.sharedPersistentStore
        let persistentContainer = CoreDataStack.shared.persistentContainer

        persistentContainer.acceptShareInvitations(from: [metadata], into: shareStore) { _, error in

            if let error = error {
                print("Error accepting share.:", error)
                return
            }

            self.waitingForSharedSync = true
            self.startSharedStorePolling()
            self.showLoadingScreen()
        }
    }

}

// MARK: - CloudKit Shared Logic Extension
extension SceneDelegate {
    
    @objc
    private func sharedStoreDidSync() {
        guard waitingForSharedSync else { return }
        
        sharedPollingTask?.cancel()
        waitingForSharedSync = false
        hideLoadingScreenAfterMinimumDelay()

        guard let patient = fetchLatestSharedPatient() else { return }

        appCoordinator?.receivedPatientViaShare = true
        appCoordinator?.sharedReceivedPatient = patient

        Task { await appCoordinator?.start() }
    }
    
    private func startSharedStorePolling() {
        sharedPollingTask?.cancel()
        sharedPollingTask = Task.detached { [weak self] in
            guard let self = self else { return }
            let timeout: TimeInterval = 30
            let start = Date()

            while Date().timeIntervalSince(start) < timeout {

                try? await Task.sleep(nanoseconds: 1_000_000_000)

                if Task.isCancelled { return }

                let currentCount = await self.countSharedPatients()
                if await currentCount > self.initialSharedCount {

                    if let patient = await self.fetchLatestSharedPatient() {

                        await MainActor.run {
                            self.hideLoadingScreenAfterMinimumDelay()
                            self.waitingForSharedSync = false
                            self.sharedPollingTask?.cancel()
                            self.appCoordinator?.receivedPatientViaShare = true
                            self.appCoordinator?.sharedReceivedPatient = patient
                            Task { await self.appCoordinator?.start() }
                        }
                    }

                    return
                }
            }
            print("Timeout waiting for a new registration in the Shared Store.")
        }
    }

    func fetchLatestSharedPatient() -> CareRecipient? {
        let context = CoreDataStack.shared.context
        let request: NSFetchRequest<CareRecipient> = CareRecipient.fetchRequest()

        request.affectedStores = [CoreDataStack.shared.sharedPersistentStore]
        request.sortDescriptors = [
            NSSortDescriptor(key: "creationDate", ascending: false)
        ]
        
        do {
            let results = try context.fetch(request)
            return results.first
        } catch {
            print("Error searching for patient in Shared Store:", error)
            return nil
        }
    }
    
    func countSharedPatients() -> Int {
        let context = CoreDataStack.shared.context
        let request: NSFetchRequest<CareRecipient> = CareRecipient.fetchRequest()
        request.affectedStores = [CoreDataStack.shared.sharedPersistentStore]

        do {
            return try context.count(for: request)
        } catch {
            print("Error counting patients in Shared Store:", error)
            return 0
        }
    }
    
    func findPatientForShareTitle(_ title: String) -> CareRecipient? {
        let context = CoreDataStack.shared.context
        let request: NSFetchRequest<CareRecipient> = CareRecipient.fetchRequest()
        request.affectedStores = [CoreDataStack.shared.sharedPersistentStore]
        
        request.predicate = NSPredicate(format: "personalData.name == %@", title)
        
        return try? context.fetch(request).first
    }
}
