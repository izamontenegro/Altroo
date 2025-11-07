//
//  Array+Extensions.swift
//  Altroo
//
//  Created by Layza Maria Rodrigues Carneiro on 04/11/25.
//

extension Array {
    func unique<Key: Hashable>(by keySelector: (Element) -> Key?) -> [Element] {
        var seen = Set<Key>()
        return filter {
            guard let key = keySelector($0) else { return false }
            return seen.insert(key).inserted
        }
    }
}
