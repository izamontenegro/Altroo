//
//  CoreDataService+CloudkitSharing.swift
//  Altroo
//
//  Created by Raissa Parente on 23/09/25.
//

import CoreData
import CloudKit

extension CoreDataStack  {
    func isShared(object: NSManagedObject) -> Bool {
        isShared(objectID: object.objectID)
    }
    
    func canEdit(object: NSManagedObject) -> Bool {
        return persistentContainer.canUpdateRecord(forManagedObjectWith: object.objectID)
    }
    
    func canDelete(object: NSManagedObject) -> Bool {
        return persistentContainer.canDeleteRecord(forManagedObjectWith: object.objectID)
    }
    
    func isOwner(object: NSManagedObject) -> Bool {
      guard isShared(object: object) else { return false }
      guard let share = try? persistentContainer.fetchShares(matching: [object.objectID])[object.objectID] else {
        print("Get ckshare error")
        return false
      }
      if let currentUser = share.currentUserParticipant, currentUser == share.owner {
        return true
      }
      return false
    }
    
    func getShare(_ careRecipient: CareRecipient) -> CKShare? {
        guard isShared(object: careRecipient) else { return nil }
        guard let shareDictionary = try? persistentContainer.fetchShares(matching: [careRecipient.objectID]),
              let share = shareDictionary[careRecipient.objectID] else {
            print("Unable to get CKShare")
            return nil
        }
        share[CKShare.SystemFieldKey.title] = careRecipient.personalData?.name
        return share
    }
    
    private func isShared(objectID: NSManagedObjectID) -> Bool {
        var isShared = false
        if let persistentStore = objectID.persistentStore {
            if persistentStore == sharedPersistentStore {
                isShared = true
            } else {
                let container = persistentContainer
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
}
