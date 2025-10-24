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
}
