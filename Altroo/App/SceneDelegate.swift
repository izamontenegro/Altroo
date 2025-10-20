//
//  SceneDelegate.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 18/09/25.
//

import UIKit

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
}
