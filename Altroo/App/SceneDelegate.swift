////
////  SceneDelegate.swift
////  Altroo
////
////  Created by Izadora de Oliveira Albuquerque Montenegro on 18/09/25.
////
//
//import UIKit
//import CloudKit
//
//class SceneDelegate: UIResponder, UIWindowSceneDelegate {
//    
//    var window: UIWindow?
//    var appCoordinator: AppCoordinator?
//    
//    func scene(_ scene: UIScene,
//               willConnectTo session: UISceneSession,
//               options connectionOptions: UIScene.ConnectionOptions) {
//        
//        guard let windowScene = scene as? UIWindowScene else { return }
//        
//        let window = UIWindow(windowScene: windowScene)
//        let navigation = UINavigationController()
//        
//        let appCoordinator = AppCoordinator(rootNavigation: navigation)
//                
//        window.rootViewController = navigation
//        window.makeKeyAndVisible()
//        window.overrideUserInterfaceStyle = .light
//        
//        self.window = window
//        self.appCoordinator = appCoordinator
//        
//        Task {
//            await appCoordinator.start()
//        }
//    }
//    
//    func windowScene(_ windowScene: UIWindowScene,
//                     userDidAcceptCloudKitShareWith cloudKitShareMetadata: CKShare.Metadata) {
//
//        let shareStore = CoreDataStack.shared.sharedPersistentStore
//        let persistentContainer = CoreDataStack.shared.persistentContainer
//
//        persistentContainer.acceptShareInvitations(from: [cloudKitShareMetadata],
//                                                   into: shareStore) { _, error in
//            if let error {
//                print("Error accepting CloudKit Share: \(error)")
//            } else {
//                print("CloudKit Share invitation successfully accepted..")
//                
//                DispatchQueue.main.async {
//                    self.appCoordinator?.receivedPatientViaShare = true
//                    
//                    Task {
//                        await self.appCoordinator?.start()
//                    }
//                }
//            }
//        }
//    }
//}
