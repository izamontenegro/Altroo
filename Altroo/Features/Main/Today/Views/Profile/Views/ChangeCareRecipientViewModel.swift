//
//  ChangeCareRecipientViewModel.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 13/10/25.
//

import UIKit
import Combine

final class ChangeCareRecipientViewModel {
    var userService: UserServiceProtocol
    
    init(userService: UserServiceProtocol) {
        self.userService = userService
    }
}
