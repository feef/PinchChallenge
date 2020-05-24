//
//  UnitTestHelpers.swift
//  CoreDataUnitTests
//
//  Created by Luke Smith on 24/10/2017.
//  Copyright © 2017 LukeSmith. All rights reserved.
//
import Foundation
import CoreData
@testable import PinchChallenge

enum CoreDataError: Error {
    case missingContext
    case errorWhileDeleting
    case couldNotCreateFetchRequest
    case errorWhileFetchingData
}

class UnitTestHelpers {
    class func setUpInMemoryManagedObjectContext() -> NSManagedObjectContext {
        let managedObjectModel = NSManagedObjectModel.mergedModel(from: Bundle.allBundles)!
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        do {
            try persistentStoreCoordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
        } catch {
            fatalError("Adding in-memory persistent store failed")
        }
        
        let context = NSManagedObjectContext.init(concurrencyType: NSManagedObjectContextConcurrencyType.mainQueueConcurrencyType)
        context.persistentStoreCoordinator = persistentStoreCoordinator
        
        /* create a dummy object, then delete it.  this avoids fetch request errors later */
        let testObject = Album(context: context)
        context.delete(testObject)
        do {
            try context.save()
        } catch {
            fatalError("Unable to save context")
        }
        
        return context
    }
}
