//
//  TodaySectionManager.swift
//  Altroo
//
//  Created by Layza Maria Rodrigues Carneiro on 20/10/25.
//

import Foundation

enum TodaySectionType: String, Codable, CaseIterable {
    case basicNeeds = "Necessidades Básicas"
    case tasks = "Tarefas"
    case intercurrences = "Intercorrências"
}

struct TodaySectionConfig: Codable {
    let type: TodaySectionType
    var isVisible: Bool
    var order: Int
    var subitems: [SubitemConfig]?
}

struct SubitemConfig: Codable {
    let title: String
    var isVisible: Bool
}


class TodaySectionManager {
    static let shared = TodaySectionManager()
    private let key = "todaySectionConfig"

    private init() {}

    func save(_ configs: [TodaySectionConfig]) {
        let data = try? JSONEncoder().encode(configs)
        UserDefaults.standard.set(data, forKey: key)
    }

    func load() -> [TodaySectionConfig] {
        guard
            let data = UserDefaults.standard.data(forKey: key),
            let configs = try? JSONDecoder().decode([TodaySectionConfig].self, from: data)
        else {
            return TodaySectionType.allCases.enumerated().map {
                TodaySectionConfig(type: $1, isVisible: true, order: $0)
            }
        }

        return configs.sorted { $0.order < $1.order }
    }
}

