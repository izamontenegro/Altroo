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
