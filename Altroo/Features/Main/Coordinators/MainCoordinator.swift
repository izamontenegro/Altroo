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
        
        
        
        // MARK: - TODAY
        let todayNav = UINavigationController()
        let todayCoord = TodayCoordinator(
            navigation: todayNav, patientService: patientService, factory: factory
        )
        add(child: todayCoord)
        todayCoord.start()
        todayNav.tabBarItem = UITabBarItem(title: "Hoje", image: UIImage(systemName: "heart.text.square.fill"), tag: 0)
        
        // MARK: - HISTORY
        let histNav = UINavigationController()
        let histCoord = HistoryCoordinator(
            navigation: histNav, patientService: patientService, factory: factory
        )
        add(child: histCoord); histCoord.start()
        histNav.tabBarItem = UITabBarItem(title: "Histórico", image: UIImage(systemName: "folder.fill"), tag: 1)
        
        // MARK: - ANALYSIS
        let analysisNav = UINavigationController()
        let analysisCoord = AnalysisCoordinator(
            navigation: analysisNav, patientService: patientService, factory: factory
        )
        add(child: analysisCoord)
        analysisCoord.start()
        analysisNav.tabBarItem = UITabBarItem(title: "Relatório", image: UIImage(systemName: "chart.bar.xaxis.ascending.badge.clock"), tag: 2)
        
        // MARK: - SETTINGS
        let settingsNav = UINavigationController()
        let settingsCoord = SettingsCoordinator(
            navigation: settingsNav, patientService: patientService, factory: factory
        )
        add(child: settingsCoord)
        settingsCoord.start()
        settingsNav.tabBarItem = UITabBarItem(title: "Ajustes", image: UIImage(systemName: "gearshape.fill"), tag: 3)

        // MARK: - TAB BAR CONFIGURATION
        
        tabBar.viewControllers = [todayNav, analysisNav, settingsNav]
        
        rootNavigation.setNavigationBarHidden(true, animated: false)
        rootNavigation.setViewControllers([tabBar], animated: false)
    }
}
