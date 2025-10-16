//
//  TodayViewModel.swift
//  Altroo
//
//  Created by Layza Maria Rodrigues Carneiro on 16/10/25.
//

import Foundation

final class TodayViewModel {
    private let userService: UserServiceProtocol
    private(set) var careRecipient: CareRecipient?
        
    init(userService: UserServiceProtocol) {
        self.userService = userService
    }
    
    func loadCareRecipient() -> CareRecipient? {
        if let existingRecipient = careRecipient {
            return existingRecipient
        }
        
        guard let user = userService.fetchCurrentPatient() else {
            return nil
        }
        
        careRecipient = user
        return user
    }
}

