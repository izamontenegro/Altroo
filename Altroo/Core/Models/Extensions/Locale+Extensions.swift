//
//  Locale+Extensions.swift
//  Altroo
//
//  Created by Raissa Parente on 08/10/25.
//

import Foundation

extension Locale.Weekday:  @retroactive CaseIterable {
    public static var allCases: [Locale.Weekday] = [.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]
}
