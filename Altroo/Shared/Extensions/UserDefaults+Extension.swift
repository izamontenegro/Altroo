//
//  UserDefaults+Extension.swift
//  Altroo
//
//  Created by Layza Maria Rodrigues Carneiro on 30/09/25.
//

import Foundation

extension UserDefaults {
    enum Keys {
        static let hasLaunchedBefore = "hasLaunchedBefore"
        static let onboardingCompleted = "onboardingCompleted"
        static let healthAlertSeen = "healthAlertSeen"
    }
    
    var isFirstLaunch: Bool {
        get {
            let first = !bool(forKey: Keys.hasLaunchedBefore)
            if first {
                set(true, forKey: Keys.hasLaunchedBefore)
            }
            return first
        }
    }
    
    var onboardingCompleted: Bool {
        get { bool(forKey: Keys.onboardingCompleted) }
        set { set(newValue, forKey: Keys.onboardingCompleted) }
    }
    
    var healthAlertSeen: Bool {
        get { bool(forKey: Keys.healthAlertSeen) }
        set { set(newValue, forKey: Keys.healthAlertSeen) }
    }
}
