//
//  CoreDataStack.swift
//  Altroo
//
//  Created by Raissa Parente on 23/09/25.
//

import CoreData
import CloudKit


class CoreDataStack {
    static let shared = CoreDataStack()
    private(set) var isCloudSynced = false
    
    //MARK: Utility vars
    var ckContainer: CKContainer {
        let storeDescription = persistentContainer.persistentStoreDescriptions.first
        guard let identifier = storeDescription?.cloudKitContainerOptions?.containerIdentifier else {
            fatalError("Unable to get container identifier")
        }
        return CKContainer(identifier: identifier)
    }
    
    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    var privatePersistentStore: NSPersistentStore {
        guard let privateStore = _privatePersistentStore else {
            fatalError("Private store is not set")
        }
        return privateStore
    }
    
    var sharedPersistentStore: NSPersistentStore {
        guard let sharedStore = _sharedPersistentStore else {
            fatalError("Shared store is not set")
        }
        return sharedStore
    }
    
    lazy var persistentContainer: NSPersistentCloudKitContainer = {
        let container = NSPersistentCloudKitContainer(name: "AltrooDataModel") //.xcdatamodeld file name
        container.persistentStoreDescriptions.forEach {
            $0.setOption(true as NSNumber,
                         forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
        }
        
        guard let privateStoreDescription = container.persistentStoreDescriptions.first else {
            fatalError("Unable to get persistentStoreDescription")
        }
        
        //MARK: Private store
        let storesURL = privateStoreDescription.url?.deletingLastPathComponent()
        privateStoreDescription.url = storesURL?.appendingPathComponent("private.sqlite")
        
        //MARK: Shared store
        let sharedStoreURL = storesURL?.appendingPathComponent("shared.sqlite")
        guard let sharedStoreDescription = privateStoreDescription.copy() as? NSPersistentStoreDescription else {
            fatalError("Copying the private store description returned an unexpected value.")
        }
        sharedStoreDescription.url = sharedStoreURL
        
        guard let containerIdentifier = privateStoreDescription.cloudKitContainerOptions?.containerIdentifier else {
            fatalError("Unable to get containerIdentifier")
        }
        let sharedStoreOptions = NSPersistentCloudKitContainerOptions(containerIdentifier: containerIdentifier)
        sharedStoreOptions.databaseScope = .shared
        sharedStoreDescription.cloudKitContainerOptions = sharedStoreOptions
        container.persistentStoreDescriptions.append(sharedStoreDescription)
        
        //MARK: Load stores
        container.loadPersistentStores { desc, error in
            if let error = error { fatalError("Store load error: \(error)") }
            
            guard let url = desc.url else { return }
            let store = container.persistentStoreCoordinator.persistentStore(for: url)
            
            if desc.cloudKitContainerOptions?.databaseScope == .private {
                self._privatePersistentStore = store
            } else {
                self._sharedPersistentStore = store
            }
        }
        
        //MARK: Context setup
//        do {
//            try container.viewContext.setQueryGenerationFrom(.current)
//        } catch {
//            fatalError("Failed to pin viewContext to the current generation: \(error)")
//        }
//        
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.automaticallyMergesChangesFromParent = true
        
        
        // Observe remote CloudKit changes
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(processRemoteChange(_:)),
            name: .NSPersistentStoreRemoteChange,
            object: container.persistentStoreCoordinator
        )

        // Observe STORE CHANGES (shared x private)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(storeDidChange(_:)),
            name: .NSPersistentStoreCoordinatorStoresDidChange,
            object: container.persistentStoreCoordinator
        )

        
        return container
    }()

    private var _privatePersistentStore: NSPersistentStore?
    private var _sharedPersistentStore: NSPersistentStore?
    private init() {}
    
    @objc func processRemoteChange(_ notification: Notification) {
        NotificationCenter.default.post(name: .didFinishCloudKitSync, object: nil)
    }

    @objc
    private func storeDidChange(_ notification: Notification) {
        guard let added = notification.userInfo?[NSAddedPersistentStoresKey] as? [NSPersistentStore] else {
            return
        }
        
        for store in added {

            if let sharedStore = _sharedPersistentStore, store == sharedStore {
                print("🔄 Shared CloudKit Store updated")
                NotificationCenter.default.post(name: .sharedStoreDidSync, object: nil)
            }
            
            if let privateStore = _privatePersistentStore, store == privateStore {
                print("🔄 Private CloudKit Store updated")
                NotificationCenter.default.post(name: .privateStoreDidSync, object: nil)
            }
        }
    }

}


extension Notification.Name {
    static let didFinishCloudKitSync = Notification.Name("didFinishCloudKitSync")
    static let sharedStoreDidSync = Notification.Name("sharedStoreDidSync")
    static let privateStoreDidSync = Notification.Name("privateStoreDidSync")
}
