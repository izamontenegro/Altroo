//
//  PerformerAttributionProviding.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 23/10/25.
//

import Foundation
import CoreData
import CloudKit

protocol PerformerAttributionProviding {
    func currentPerformerName(for object: NSManagedObject) -> String
}

extension CoreDataService: PerformerAttributionProviding {
    public func currentPerformerName(for object: NSManagedObject) -> String {
        guard let shares = try? stack.persistentContainer.fetchShares(matching: [object.objectID]),
              let share = shares[object.objectID] else {
            return "You"
        }

        guard let me = share.currentUserParticipant else {
            return "You"
        }

        if let formatted = me.userIdentity.nameComponents?.formatted(.name(style: .long)).trimmingCharacters(in: .whitespacesAndNewlines),
           !formatted.isEmpty {
            return formatted
        }

        let context = stack.persistentContainer.viewContext
        if let matched = matchUser(for: me, in: context),
           let name = (matched.value(forKey: "name") as? String)?.trimmingCharacters(in: .whitespacesAndNewlines),
           !name.isEmpty {
            return name
        }

        let isOwner: Bool
        if #available(iOS 15.0, *) {
            isOwner = (me.role == .owner)
        } else {
            isOwner = (me.userIdentity.lookupInfo == nil)
        }

        if isOwner { return "You" }

        if let email = me.userIdentity.lookupInfo?.emailAddress, !email.isEmpty { return email }
        if let phone = me.userIdentity.lookupInfo?.phoneNumber, !phone.isEmpty { return phone }

        return "iCloud User"
    }
}
