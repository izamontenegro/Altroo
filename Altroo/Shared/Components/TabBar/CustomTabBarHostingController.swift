//
//  CustomTabBarHostingController.swift
//  Altroo
//
//  Created by Marcelle Ribeiro Queiroz on 15/10/25.
//

import UIKit
import SwiftUI

final class CustomTabBarHostingController: UIHostingController<CustomTabBar> {
    
    var onTabSelected: ((Tab) -> Void)?
    
    init(currentTab: Binding<Tab>, onTabSelected: @escaping (Tab) -> Void) {
        let customTabBar = CustomTabBar(currentTab: currentTab)
        self.onTabSelected = onTabSelected
        super.init(rootView: customTabBar)
        
        // Update the selection closure within SwiftUI
        self.rootView = CustomTabBar(currentTab: currentTab)
    }
    
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
