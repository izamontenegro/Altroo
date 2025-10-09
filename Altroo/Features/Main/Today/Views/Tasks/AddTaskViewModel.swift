//
//  AddTaskViewModel.swift
//  Altroo
//
//  Created by Raissa Parente on 08/10/25.
//
import Combine
import Foundation
import UIKit

class AddTaskViewModel {
    @Published var name: String = ""
    @Published var times: [Date] = []
    @Published var repeatingDays: [Locale.Weekday] = []
    @Published var startDate: Date = .now
    @Published var endDate: Date = .now
    @Published var note: String = ""
    
    @Published var isContinuous: Bool = true
    let continuousOptions = ["Continuous", "End Date"]
    var continuousButtonTitle: String {
        if isContinuous {
            continuousOptions[0]
        } else {
            continuousOptions[1]
        }
    }

}
