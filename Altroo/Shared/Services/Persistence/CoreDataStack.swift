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
//    init() {}
    
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
        
        guard let privateStoreDescription = container.persistentStoreDescriptions.first else {
            fatalError("Unable to get persistentStoreDescription")
        }
        
        //MARK: Private store
        let storesURL = privateStoreDescription.url?.deletingLastPathComponent()
        privateStoreDescription.url = storesURL?.appendingPathComponent("private.sqlite")
//
//        var privatePersistentStore: NSPersistentStore {
//            guard let privateStore = _privatePersistentStore else {
//                fatalError("Private store is not set")
//            }
//            return privateStore
//        }
        
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
        container.loadPersistentStores { loadedStoreDescription, error in
            if let error = error as NSError? {
                fatalError("Failed to load persistent stores: \(error)")
            } else if let cloudKitContainerOptions = loadedStoreDescription.cloudKitContainerOptions {
                guard let loadedStoreDescritionURL = loadedStoreDescription.url else {
                    return
                }
                
                if cloudKitContainerOptions.databaseScope == .private {
                    let privateStore = container.persistentStoreCoordinator.persistentStore(for: loadedStoreDescritionURL)
                    self._privatePersistentStore = privateStore
                } else if cloudKitContainerOptions.databaseScope == .shared {
                    let sharedStore = container.persistentStoreCoordinator.persistentStore(for: loadedStoreDescritionURL)
                    self._sharedPersistentStore = sharedStore
                }
            }
        }
        
//        NotificationCenter.default.addObserver(
//            forName: NSPersistentCloudKitContainer.eventChangedNotification,
//            object: container,
//            queue: .main
//        ) { notification in
//            guard let event = notification.userInfo?[NSPersistentCloudKitContainer.eventNotificationUserInfoKey] as? NSPersistentCloudKitContainer.Event else { return }
//
//            if event.type == .import && event.endDate != nil {
//                self.isCloudSynced = true
//                NotificationCenter.default.post(name: .didFinishCloudKitSync, object: nil)
//            }
//        }

        
        //MARK: Context setup
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.automaticallyMergesChangesFromParent = true
        do {
            try container.viewContext.setQueryGenerationFrom(.current)
        } catch {
            fatalError("Failed to pin viewContext to the current generation: \(error)")
        }
        
        return container
    }()

    private var _privatePersistentStore: NSPersistentStore?
    private var _sharedPersistentStore: NSPersistentStore?
    private init() {}
}

extension CoreDataStack {

//    private var isCloudKitReady: Bool {
//        _privatePersistentStore != nil && _sharedPersistentStore != nil
//    }
//    
//    func waitForCloudKitSync() async {
//        if isCloudSynced { return }
//
//        return await withCheckedContinuation { continuation in
//            NotificationCenter.default.addObserver(
//                forName: .didFinishCloudKitSync,
//                object: nil,
//                queue: .main
//            ) { _ in
//                self.isCloudSynced = true
//                continuation.resume()
//            }
//        }
//    }
}

extension Notification.Name {
    static let didFinishCloudKitSync = Notification.Name("didFinishCloudKitSync")
}
