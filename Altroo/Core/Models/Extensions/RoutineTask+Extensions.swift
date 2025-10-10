//
//  RoutineTask+Extensions.swift
//  Altroo
//
//  Created by Raissa Parente on 09/10/25.
//

import Foundation

//TODO: CHECK
extension RoutineTask {
    var period: PeriodEnum {
        let hour = Calendar.current.component(.hour, from: time!)
        
        switch hour {
        case 5..<12:
            return .morning
        case 12..<17:
            return .afternoon
        case 17..<21:
            return .evening
        default:
            return .night
        }
    }
}
