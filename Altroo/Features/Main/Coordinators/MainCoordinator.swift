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
    weak var parentCoordinator: AppCoordinator?
    
    func makeProfileCoordinator(using navigation: UINavigationController) -> ProfileCoordinator {
        let coord = ProfileCoordinator(
            navigation: navigation,
            factory: factory,
            associateFactory: factory
        )
        
        coord.onEndCare = { [weak self] in
            Task { @MainActor in
                self?.parentCoordinator?.restartToAllPatients()
            }
        }
        
        return coord
    }
    
    func start() {
        let tabBar = AppTabBarController()
        self.tabBar = tabBar
        
        // MARK: - PATIENTS
        let patientsNav = UINavigationController()
        let patientsCoord = PatientsCoordinator(
            navigation: patientsNav, factory: factory
        )
        patientsCoord.parentCoordinator = self
        add(child: patientsCoord)
        patientsCoord.start()
        patientsNav.tabBarItem = UITabBarItem(title: "Assistidos", image: UIImage(systemName: "person.fill"), tag: 0)
        
        // MARK: - REPORTS
        let analysisNav = UINavigationController()
        let analysisCoord = AnalysisCoordinator(
            navigation: analysisNav, factory: factory
        )
        add(child: analysisCoord)
        analysisCoord.start()
        analysisNav.tabBarItem = UITabBarItem(title: "Relatório", image: UIImage(systemName: "chart.bar.xaxis.ascending.badge.clock"), tag: 0)
        
        // MARK: - TODAY
        let todayNav = UINavigationController()
        let todayCoord = TodayCoordinator(
            navigation: todayNav, factory: factory
        )
        todayCoord.parentCoordinator = self
        add(child: todayCoord)
        todayCoord.start()
        todayNav.tabBarItem = UITabBarItem(title: "Hoje", image: UIImage(systemName: "heart.text.square.fill"), tag: 1)
        
        // MARK: - HISTORY
        let histNav = UINavigationController()
        let histCoord = HistoryCoordinator(
            navigation: histNav, factory: factory
        )
        add(child: histCoord); histCoord.start()
        histNav.tabBarItem = UITabBarItem(title: "Histórico", image: UIImage(systemName: "folder.fill"), tag: 2)
        
        // MARK: - SETTINGS
        let settingsNav = UINavigationController()
        let settingsCoord = SettingsCoordinator(
            navigation: settingsNav, factory: factory
        )
        add(child: settingsCoord)
        settingsCoord.start()
        settingsNav.tabBarItem = UITabBarItem(title: "Ajustes", image: UIImage(systemName: "gear"), tag: 3)
        
        // MARK: - TAB BAR CONFIGURATION
        tabBar.viewControllers = [patientsNav, analysisNav, todayNav, histNav, settingsNav]
        
        for case let nav as UINavigationController in tabBar.viewControllers ?? [] {
            nav.delegate = tabBar
        }
        
        tabBar.selectedIndex = 2
        
        navigation.setNavigationBarHidden(true, animated: false)
        navigation.setViewControllers([tabBar], animated: false)
    }
}
