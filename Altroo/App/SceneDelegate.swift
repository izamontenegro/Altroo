//
//  SceneDelegate.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 18/09/25.
//

import UIKit
import CloudKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    var appCoordinator: AppCoordinator?
    
    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = scene as? UIWindowScene else { return }
        
        let window = UIWindow(windowScene: windowScene)
        let navigation = UINavigationController()
        
        let appCoordinator = AppCoordinator(rootNavigation: navigation)
        appCoordinator.start()
        
        window.overrideUserInterfaceStyle = .light
        window.rootViewController = navigation
        window.makeKeyAndVisible()
        
        self.window = window
        self.appCoordinator = appCoordinator
    }
    
    func windowScene(_ windowScene: UIWindowScene,
                     userDidAcceptCloudKitShareWith cloudKitShareMetadata: CKShare.Metadata) {

        print("Usuário aceitou um CloudKit Share")

        let shareStore = CoreDataStack.shared.sharedPersistentStore
        let persistentContainer = CoreDataStack.shared.persistentContainer

        persistentContainer.acceptShareInvitations(from: [cloudKitShareMetadata],
                                                   into: shareStore) { _, error in
            if let error {
                print("Erro ao aceitar o CloudKit Share: \(error)")
            } else {
                print("Convite CloudKit Share aceito com sucesso.")
                
                DispatchQueue.main.async {
                    self.appCoordinator?.receivedPatientViaShare = true

                    // Reinicia fluxo para ir direto ao main flow
                    self.appCoordinator?.start()
                }
            }
            

        }
    }
}
