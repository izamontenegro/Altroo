//
//  MyProfileViewModel.swift
//  Altroo
//
//  Created by Marcelle Ribeiro Queiroz on 17/11/25.
//

import Foundation
import Combine

class MyProfileViewModel {
    
    private var userService: UserServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    @Published private(set) var caregiverUser: User? = nil
    
    @Published private(set) var caregiverPhone: String = ""
    @Published private(set) var caregiverName: String = "Desconhecido"

    init(userService: UserServiceProtocol) {
        self.userService = userService
        
        refreshData()
        
        userService.cloudKitDidChangePublisher
            .sink { [weak self] in
                self?.refreshData()
            }
            .store(in: &cancellables)
    }
    
    func refreshData() {
        caregiverUser = userService.fetchUser()
        caregiverName = caregiverUser?.name ?? "Desconhecido"
        caregiverPhone = caregiverUser?.phone ?? "Sem contato"
    }
    
    func updateName(_ newName: String) {
        caregiverName = newName
        userService.setName(newName)
    }
    
    func updatePhone(_ newPhone: String) {
        caregiverPhone = newPhone
        userService.setPhone(newPhone)
    }
}
