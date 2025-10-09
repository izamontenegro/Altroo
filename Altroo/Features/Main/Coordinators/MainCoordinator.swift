//
//  MainCoordinator.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 22/09/25.
//

import UIKit

final class MainCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    private let rootNavigation: UINavigationController
    private let patientService: PatientService
    private let factory: AppFactory
    
    var onLogout: (() -> Void)?
    
    init(navigation: UINavigationController, patientService: PatientService, factory: AppFactory) {
        self.rootNavigation = navigation
        self.patientService = patientService
        self.factory = factory
    }
    
    private weak var tabBar: AppTabBarController?
    
    func start() {
        let tabBar = AppTabBarController()
        self.tabBar = tabBar
        
        // MARK: - SETTINGS
        let settingsNav = UINavigationController()
        let settingsCoord = SettingsCoordinator(
            navigation: settingsNav, patientService: patientService, factory: factory
        )
        add(child: settingsCoord)
        settingsCoord.start()
        settingsNav.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "gear"), tag: 0)
               
        // MARK: - TODAY
        let todayNav = UINavigationController()
        let todayCoord = TodayCoordinator(
            navigation: todayNav, patientService: patientService, factory: factory
        )
        add(child: todayCoord)
        todayCoord.start()
        todayNav.tabBarItem = UITabBarItem(title: "Today", image: UIImage(systemName: "house"), tag: 0)
        
        // MARK: - HISTORY
        let histNav = UINavigationController()
        let histCoord = HistoryCoordinator(
            navigation: histNav, patientService: patientService, factory: factory
        )
        add(child: histCoord); histCoord.start()
        histNav.tabBarItem = UITabBarItem(title: "History", image: UIImage(systemName: "clock"), tag: 1)
        
        // MARK: - ANALYSIS
        let analysisNav = UINavigationController()
        let analysisCoord = AnalysisCoordinator(
            navigation: analysisNav, patientService: patientService, factory: factory
        )
        add(child: analysisCoord)
        analysisCoord.start()
        analysisNav.tabBarItem = UITabBarItem(title: "Analysis", image: UIImage(systemName: "doc.text"), tag: 2)
        
        // MARK: - TAB BAR CONFIGURATION
        
        tabBar.viewControllers = [settingsNav, todayNav, histNav, analysisNav]
        
        rootNavigation.setNavigationBarHidden(true, animated: false)
        rootNavigation.setViewControllers([tabBar], animated: false)
    }
}
