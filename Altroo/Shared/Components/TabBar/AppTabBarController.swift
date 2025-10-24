//
//  AppTabBarController.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 22/09/25.
//

import UIKit
import SwiftUI
import Combine

class TabModel: ObservableObject {
    @Published var currentTab: Tab = .today
}

final class AppTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    let model = TabModel()
    
    lazy var customTabBar: UIView = {
        let configuration = UIHostingConfiguration {
            CustomTabBar(model: model)
        }
            .margins(.all, 0)
        
        let view = configuration.makeContentView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var cancallable: AnyCancellable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 17.0, *) {
            self.traitOverrides.horizontalSizeClass = .compact
        } else { }
        delegate = self
        setupAppearance()
        setupCustomTabBar()
        
        //FIXME: Take this out when there is more thing for the tabbar
//        customTabBar.isHidden = true
    }
    
    //FIXME: Investigate if this will work when there is custom tabbar
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tabBar.isHidden = true
        tabBar.frame = .zero
    }
    
    private func setupAppearance() {
        tabBar.isHidden = true
        tabBar.frame = .zero
        tabBar.layer.opacity = 0
        view.backgroundColor = .clear
    }
    
    private func setupCustomTabBar() {
        view.addSubview(customTabBar)
        customTabBar.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            customTabBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customTabBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            customTabBar.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 12),
            customTabBar.heightAnchor.constraint(equalToConstant: 70)
        ])
        
        cancallable = model.$currentTab.sink { [weak self] value in
            guard let self else { return }
            self.selectTab(value)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func selectTab(_ tab: Tab) {
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
            model.currentTab = newTab
        }
    }
}
