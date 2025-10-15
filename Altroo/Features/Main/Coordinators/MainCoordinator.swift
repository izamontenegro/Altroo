//
//  MainCoordinator.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 22/09/25.
//

import UIKit

final class MainCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    var navigation: UINavigationController
    private let factory: AppFactory
    
    var onLogout: (() -> Void)?
    
    init(navigation: UINavigationController, factory: AppFactory) {
        self.navigation = navigation
        self.factory = factory
    }
    
    private weak var tabBar: AppTabBarController?
    
    func start() {
        let tabBar = AppTabBarController()
        self.tabBar = tabBar
        
        // MARK: - SETTINGS
        let settingsNav = UINavigationController()
        let settingsCoord = SettingsCoordinator(
            navigation: settingsNav, factory: factory
        )
        add(child: settingsCoord)
        settingsCoord.start()
        settingsNav.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "gear"), tag: 0)
               
        // MARK: - TODAY
        let todayNav = UINavigationController()
        let todayCoord = TodayCoordinator(
            navigation: todayNav, factory: factory
        )
        add(child: todayCoord)
        todayCoord.start()
        todayNav.tabBarItem = UITabBarItem(title: "Hoje", image: UIImage(systemName: "heart.text.square.fill"), tag: 0)
        
        // MARK: - HISTORY
        let histNav = UINavigationController()
        let histCoord = HistoryCoordinator(
            navigation: histNav, factory: factory
        )
        add(child: histCoord); histCoord.start()
        histNav.tabBarItem = UITabBarItem(title: "Histórico", image: UIImage(systemName: "folder.fill"), tag: 1)
        
        // MARK: - ANALYSIS
        let analysisNav = UINavigationController()
        let analysisCoord = AnalysisCoordinator(
            navigation: analysisNav, factory: factory
        )
        add(child: analysisCoord)
        analysisCoord.start()
        analysisNav.tabBarItem = UITabBarItem(title: "Relatório", image: UIImage(systemName: "chart.bar.xaxis.ascending.badge.clock"), tag: 2)
        
        // MARK: - TAB BAR CONFIGURATION
        
        tabBar.viewControllers = [todayNav, analysisNav, settingsNav]
        
        navigation.setNavigationBarHidden(true, animated: false)
        navigation.setViewControllers([tabBar], animated: false)
    }
}
