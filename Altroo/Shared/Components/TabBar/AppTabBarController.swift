//
//  AppTabBarController.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 22/09/25.
//

import UIKit
import SwiftUI

final class AppTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    private var hostingController: UIHostingController<CustomTabBar>?
    @State private var currentTab: Tab = .today
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        setupAppearance()
        setupCustomTabBar()
    }
    
    private func setupAppearance() {
        tabBar.isHidden = true
        view.backgroundColor = .clear
    }
    
    private func setupCustomTabBar() {
        let binding = Binding<Tab>(
            get: { self.currentTab },
            set: { [weak self] newTab in
                withAnimation(.easeInOut(duration: 0.25)) {
                    self?.selectTab(newTab)
                }
            }
        )
        
        let customTabBar = CustomTabBar(currentTab: binding)
        let host = UIHostingController(rootView: customTabBar)
        addChild(host)
        view.addSubview(host.view)
        host.didMove(toParent: self)
        hostingController = host
        
        host.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            host.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            host.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            host.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            host.view.heightAnchor.constraint(equalToConstant: 85)
        ])
    }
    
    private func selectTab(_ tab: Tab) {
        currentTab = tab
        switch tab {
        case .today: selectedIndex = 0
        case .history: selectedIndex = 1
        case .report: selectedIndex = 2
        case .settings: selectedIndex = 3
        }
    }
    // MARK: - UIKit → SwiftUI synchronization
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let newTab: Tab
        switch selectedIndex {
        case 0: newTab = .today
        case 1: newTab = .history
        case 2: newTab = .report
        case 3: newTab = .settings
        default: newTab = .today
        }
        
        withAnimation(.easeInOut(duration: 0.25)) {
            currentTab = newTab
            hostingController?.rootView.currentTab = newTab
        }
    }
}
