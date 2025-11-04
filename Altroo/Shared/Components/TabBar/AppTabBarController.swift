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
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleTabBarVisibility(_:)),
            name: .toggleTabBarVisibility,
            object: nil
        )
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
        case .patients: selectedIndex = 0
        case .report: selectedIndex = 1
        case .today: selectedIndex = 2
        case .history: selectedIndex = 3
        case .settings: selectedIndex = 4
        }
    }
    // MARK: - UIKit → SwiftUI synchronization
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let newTab: Tab
        switch selectedIndex {
        case 0: newTab = .patients
        case 1: newTab = .report
        case 2: newTab = .today
        case 3: newTab = .history
        case 4: newTab = .settings
        default: newTab = .today
        }
        
        withAnimation(.easeInOut(duration: 0.25)) {
            model.currentTab = newTab
        }
    }
    
    @objc private func handleTabBarVisibility(_ notification: Notification) {
        guard let hidden = notification.userInfo?["hidden"] as? Bool else { return }
        setTabBar(hidden: hidden)
    }
}

extension AppTabBarController {
    func setTabBar(hidden: Bool, animated: Bool = true) {
        guard customTabBar.isHidden != hidden else { return }
        
        if animated {
            if hidden {
                UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut]) {
                    self.customTabBar.alpha = 0
                    self.customTabBar.transform = CGAffineTransform(translationX: 0, y: 20)
                } completion: { _ in
                    self.customTabBar.isHidden = true
                    self.customTabBar.transform = .identity
                }
            } else {
                self.customTabBar.isHidden = false
                self.customTabBar.alpha = 0
                self.customTabBar.transform = CGAffineTransform(translationX: 0, y: 20)
                
                UIView.animate(withDuration: 0.35, delay: 0.05, options: [.curveEaseInOut]) {
                    self.customTabBar.alpha = 1
                    self.customTabBar.transform = .identity
                }
            }
        } else {
            customTabBar.isHidden = hidden
            customTabBar.alpha = hidden ? 0 : 1
            customTabBar.transform = .identity
        }
    }
}


extension Notification.Name {
    static let toggleTabBarVisibility = Notification.Name("toggleTabBarVisibility")
}
