//
//  PersonalData+Extensions.swift
//  Altroo
//
//  Created by Layza Maria Rodrigues Carneiro on 23/09/25.
//

import CoreData

extension PersonalData {
    
    var age: Int {
        guard let birthDate = self.dateOfBirth else { return 0 }

        let now = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year], from: birthDate, to: now)
                
        return components.year ?? 0
    }
    
}
