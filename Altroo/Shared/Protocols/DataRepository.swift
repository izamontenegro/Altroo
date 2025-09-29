//
//  DataRepository.swift
//  Altroo
//
//  Created by Raissa Parente on 26/09/25.
//

protocol DataRepository {
    func save()
    func fetchAllCareRecipients() -> [CareRecipient]
    func deleteCareRecipient(_ careRecipient: CareRecipient)
}
