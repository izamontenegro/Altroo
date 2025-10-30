//
//  Untitled.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 14/10/25.
//

import CoreData
import CloudKit

struct ParticipantsAccess {
    let name: String
    let category: String
    let permission: CKShare.ParticipantPermission
}

extension CoreDataService {
    
    func fetchParticipants(for object: NSManagedObject) -> [CKShare.Participant]? {
        guard stack.isShared(object: object) else { return nil }
        do {
            let shares = try stack.persistentContainer.fetchShares(matching: [object.objectID])
            guard let share = shares[object.objectID] else { return nil }
            
            var participants = share.participants
            participants.append(share.owner)
            return participants
        } catch {
            print("Erro ao buscar CKShare/participants: \(error.localizedDescription)")
            return nil
        }
    }
    
    
    func updateParticipantPermission(for object: NSManagedObject,
                                     participant: CKShare.Participant,
                                     to newPermission: CKShare.ParticipantPermission,
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
    
    func participantsWithCategory(for object: NSManagedObject) -> [ParticipantsAccess] {
        guard let participants = fetchParticipants(for: object) else { return [] }
        
        let context = stack.persistentContainer.viewContext
        let users: [User] = {
            let request = User.fetchRequest()
            return (try? context.fetch(request)) ?? []
        }()
        
        var byEmail: [String: User] = [:]
        var byPhone: [String: User] = [:]
        var byRecordName: [String: User] = [:]
        
        for u in users {
            if let email = u.email?.lowercased() { byEmail[email] = u }
            if let phone = u.phone?.onlyDigits() { byPhone[phone] = u }
            if let recordName = u.cloudKitRecordName { byRecordName[recordName] = u }
        }
        
        var result: [ParticipantsAccess] = []
        
        for part in participants {
            let email = part.userIdentity.lookupInfo?.emailAddress?.lowercased()
            let phone = part.userIdentity.lookupInfo?.phoneNumber?.onlyDigits()
            let recordName = part.userIdentity.userRecordID?.recordName

            let matchedUser =
                (email.flatMap { byEmail[$0] }) ??
                (phone.flatMap { byPhone[$0] }) ??
                (recordName.flatMap { byRecordName[$0] })

            let isOwner: Bool
            if #available(iOS 15.0, *) {
                isOwner = (part.role == .owner)
            } else {
                isOwner = (part.userIdentity.lookupInfo == nil)
            }

           
            let nameFromCK = part.userIdentity.nameComponents?.formatted(.name(style: .long)).trimmingCharacters(in: .whitespacesAndNewlines)
            let nameFromUser = (matchedUser?.value(forKey: "name") as? String)?.trimmingCharacters(in: .whitespacesAndNewlines)
            let displayName: String = {
                if let nameFromCK = nameFromCK, !nameFromCK.isEmpty { return nameFromCK }
                if let nameFromUser = nameFromUser, !nameFromUser.isEmpty { return nameFromUser }
                if isOwner { return "Você" }
                if let email = email, !email.isEmpty { return email }
                if let phone = phone, !phone.isEmpty { return phone }
                return "Usuário do iCloud"
            }()

            let category = matchedUser?.category ?? "—"
            let permission = part.permission

            result.append(.init(name: displayName, category: category, permission: permission))
        }
        return result
    }
    
    func matchUser(for participant: CKShare.Participant, in context: NSManagedObjectContext) -> User? {
        let email = participant.userIdentity.lookupInfo?.emailAddress?.lowerTrimmed
        let phone = participant.userIdentity.lookupInfo?.phoneNumber?.onlyDigits()
        let recordName = participant.userIdentity.userRecordID?.recordName
        
        let request = User.fetchRequest()
        var predicates: [NSPredicate] = []
        
        if let email {
            predicates.append(NSPredicate(format: "email == %@", email))
        }
        if let phone {
            predicates.append(NSPredicate(format: "phone == %@", phone))
        }
        if let recordName {
            predicates.append(NSPredicate(format: "cloudKitRecordName == %@", recordName))
        }
        
        guard !predicates.isEmpty else { return nil }
        
        request.predicate = NSCompoundPredicate(orPredicateWithSubpredicates: predicates)
        request.fetchLimit = 1
        
        return try? context.fetch(request).first
    }
}
