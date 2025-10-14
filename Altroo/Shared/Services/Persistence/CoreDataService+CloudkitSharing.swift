//
//  CoreDataService+CloudkitSharing.swift
//  Altroo
//
//  Created by Raissa Parente on 23/09/25.
//

import CoreData
import CloudKit

extension String {
    func onlyDigits() -> String {
        filter(\.isNumber)
    }
    
    var lowerTrimmed: String { trimmingCharacters(in: .whitespacesAndNewlines).lowercased() }
}


extension CoreDataService  {
    func isShared(object: NSManagedObject) -> Bool {
        isShared(objectID: object.objectID)
    }
    
    func canEdit(object: NSManagedObject) -> Bool {
        return stack.persistentContainer.canUpdateRecord(forManagedObjectWith: object.objectID)
    }
    
    func canDelete(object: NSManagedObject) -> Bool {
        return stack.persistentContainer.canDeleteRecord(forManagedObjectWith: object.objectID)
    }
    
    func isOwner(object: NSManagedObject) -> Bool {
        guard isShared(object: object) else { return false }
        
        do {
            let shares = try stack.persistentContainer.fetchShares(matching: [object.objectID])
            guard let share = shares[object.objectID] else {
                print("No CKShare found for this object")
                return false
            }
            
            if let currentUser = share.currentUserParticipant, currentUser == share.owner {
                return true
            }
            
        } catch {
            print("Get CKShare error: \(error.localizedDescription)")
            return false
        }
        
        return false
    }
    
    func getShare(_ careRecipient: CareRecipient) -> CKShare? {
        guard isShared(object: careRecipient) else { return nil }
        guard let shareDictionary = try? stack.persistentContainer.fetchShares(matching: [careRecipient.objectID]),
              let share = shareDictionary[careRecipient.objectID] else {
            print("Unable to get CKShare")
            return nil
        }
        share[CKShare.SystemFieldKey.title] = careRecipient.personalData?.name
        return share
    }
    
    func fetchParticipants(for object: NSManagedObject) -> [CKShare.Participant]? {
        guard isShared(object: object) else { return nil }
        do {
            let shares = try stack.persistentContainer.fetchShares(matching: [object.objectID])
            guard let share = shares[object.objectID] else { return nil }
            return share.participants
        } catch {
            print("Erro ao buscar CKShare/participants: \(error.localizedDescription)")
            return nil
        }
    }
    
    private func isShared(objectID: NSManagedObjectID) -> Bool {
        var isShared = false
        if let persistentStore = objectID.persistentStore {
            if persistentStore == stack.sharedPersistentStore {
                isShared = true
            } else {
                let container = stack.persistentContainer
                do {
                    let shares = try container.fetchShares(matching: [objectID])
                    if shares.first != nil {
                        isShared = true
                    }
                } catch {
                    print("Failed to fetch share for \(objectID): \(error)")
                }
            }
        }
        return isShared
    }
    
    func updateParticipantPermission(for object: NSManagedObject,
                                     participant: CKShare.Participant,
                                     to newPermission: CKShare.Participant.Permission,
                                     completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let shares = try stack.persistentContainer.fetchShares(matching: [object.objectID])
            guard let share = shares[object.objectID] else {
                return completion(.failure(NSError(domain: "Share", code: 404, userInfo: [NSLocalizedDescriptionKey: "Share não encontrado"])))
            }
            guard share.currentUserParticipant == share.owner else {
                return completion(.failure(NSError(domain: "Share", code: 403, userInfo: [NSLocalizedDescriptionKey: "Apenas o dono pode alterar permissões."])))
            }

            participant.permission = newPermission

            let ckContainer = stack.ckContainer
            let db = ckContainer.privateCloudDatabase // dono salva no private
            let op = CKModifyRecordsOperation(recordsToSave: [share], recordIDsToDelete: nil)
            op.savePolicy = .changedKeys
            op.modifyRecordsCompletionBlock = { _, _, error in
                if let error = error { completion(.failure(error)) }
                else { completion(.success(())) }
            }
            db.add(op)
        } catch {
            completion(.failure(error))
        }
    }
}


struct ParticipantsAccess {
    let name: String
    let category: String
    let permission: CKShare.Participant.Permission
}

extension CoreDataService {
    func participantsWithCategory(for object: NSManagedObject) -> [ParticipantsAccess] {
        guard let parts = fetchParticipants(for: object) else { return [] }

        let ctx = stack.persistentContainer.viewContext
        let users: [User] = {
            let req = User.fetchRequest()
            return (try? ctx.fetch(req)) ?? []
        }()

        var byEmail: [String: User] = [:]
        var byPhone: [String: User] = [:]
        var byRecordName: [String: User] = [:]

        for u in users {
            if let email = u.email?.lowercased() { byEmail[email] = u }
            if let phone = u.phone?.onlyDigits() { byPhone[phone] = u }
            if let rec = u.cloudKitRecordName { byRecordName[rec] = u }
        }

        var result: [ParticipantsAccess] = []

        for p in parts {
            let email = p.userIdentity.lookupInfo?.emailAddress?.lowercased()
            let phone = p.userIdentity.lookupInfo?.phoneNumber?.onlyDigits()
            let recordName = p.userIdentity.userRecordID?.recordName

            let matchedUser =
                (email.flatMap { byEmail[$0] }) ??
                (phone.flatMap { byPhone[$0] }) ??
                (recordName.flatMap { byRecordName[$0] })

            let displayName =
                p.userIdentity.nameComponents?.formatted(.name(style: .long)) ??
                email ?? phone ?? "Usuário do iCloud"

            let category = matchedUser?.category ?? "—"
            let perm = p.permission

            result.append(.init(name: displayName, category: category, permission: perm))
        }

        return result
    }
}

extension CoreDataService {
    func matchUser(for participant: CKShare.Participant, in ctx: NSManagedObjectContext) -> User? {
        let email = participant.userIdentity.lookupInfo?.emailAddress?.lowerTrimmed
        let phone = participant.userIdentity.lookupInfo?.phoneNumber?.onlyDigits()
        let recordName = participant.userIdentity.userRecordID?.recordName

        let req = User.fetchRequest()
        var preds: [NSPredicate] = []

        if let email {
            preds.append(NSPredicate(format: "email == %@", email))
        }
        if let phone {
            preds.append(NSPredicate(format: "phone == %@", phone))
        }
        if let recordName {
            preds.append(NSPredicate(format: "cloudKitRecordName == %@", recordName))
        }

        guard !preds.isEmpty else { return nil }

        req.predicate = NSCompoundPredicate(orPredicateWithSubpredicates: preds)
        req.fetchLimit = 1

        return try? ctx.fetch(req).first
    }
}
