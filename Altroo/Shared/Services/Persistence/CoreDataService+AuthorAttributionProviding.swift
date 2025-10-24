//
//  PerformerAttributionProviding.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 23/10/25.
//

import Foundation
import CoreData
import CloudKit

protocol AuthorAttributionProviding {
    func currentPerformerName(for object: NSManagedObject) -> String
}

extension CoreDataService: AuthorAttributionProviding {

    public func currentPerformerName(for object: NSManagedObject) -> String {
        guard
            let shares = try? stack.persistentContainer.fetchShares(matching: [object.objectID]),
            let share = shares[object.objectID]
        else {
            return localAppUserNameFromCoreData()
        }

        guard let me = share.currentUserParticipant else {
            return localAppUserNameFromCoreData()
        }

        if let formatted = me.userIdentity.nameComponents?
            .formatted(.name(style: .long))
            .trimmingCharacters(in: .whitespacesAndNewlines),
           !formatted.isEmpty {
            return formatted
        }

        if let matched = matchLocalUserName(with: me),
           !matched.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return matched
        }

        let isOwner: Bool
        if #available(iOS 15.0, *) {
            isOwner = (me.role == .owner)
        } else {
            isOwner = (me.userIdentity.lookupInfo == nil)
        }
        
        if isOwner {
            return localAppUserNameFromCoreData()
        }

        if let email = me.userIdentity.lookupInfo?.emailAddress,
           !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return email
        }
        if let phone = me.userIdentity.lookupInfo?.phoneNumber,
           !phone.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return phone
        }

        return "iCloud User"
    }
}


private extension CoreDataService {

    func localAppUserNameFromCoreData() -> String {
        let context = stack.persistentContainer.viewContext
        let request = User.fetchRequest()
        request.fetchLimit = 1
        if let user = (try? context.fetch(request))?.first,
           let name = user.name?.trimmingCharacters(in: .whitespacesAndNewlines),
           !name.isEmpty {
            return name
        }
        return "User"
    }

    func matchLocalUserName(with participant: CKShare.Participant) -> String? {
        let context = stack.persistentContainer.viewContext
        let request = User.fetchRequest()
        request.fetchLimit = 1
        guard let user = (try? context.fetch(request))?.first else { return nil }

        if let pEmail = participant.userIdentity.lookupInfo?.emailAddress?
            .trimmingCharacters(in: .whitespacesAndNewlines).lowercased(),
           let uEmail = user.email?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased(),
           !pEmail.isEmpty, !uEmail.isEmpty, pEmail == uEmail {
            return user.name
        }

        let digits: (String) -> String = { $0.filter(\.isNumber) }
        if let pPhone = participant.userIdentity.lookupInfo?.phoneNumber,
           let uPhone = user.phone,
           !digits(pPhone).isEmpty, !digits(uPhone).isEmpty,
           digits(pPhone) == digits(uPhone) {
            return user.name
        }

        if let pRecord = participant.userIdentity.userRecordID?.recordName,
           let uRecord = user.cloudKitRecordName,
           !pRecord.isEmpty, pRecord == uRecord {
            return user.name
        }

        return nil
    }
}
