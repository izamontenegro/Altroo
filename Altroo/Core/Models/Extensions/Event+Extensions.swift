//
//  Event+Extensions.swift
//  Altroo
//
//  Created by Layza Maria Rodrigues Carneiro on 24/09/25.
//

import CoreData

extension CareRecipientEvent {
    
    var categoryState: CategoryEventEnum? {
        get {
            guard let rawValue = self.category else { return nil }
            return CategoryEventEnum(rawValue: rawValue)
        }
        set {
            self.category = newValue?.rawValue
        }
    }
    
}
