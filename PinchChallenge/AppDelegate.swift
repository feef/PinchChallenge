//
//  AppDelegate.swift
//  PinchChallenge
//
//  Created by Feef Anthony on 5/16/20.
//  Copyright © 2020 Feef Anthony. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        guard
            let navigationController = window?.rootViewController as? UINavigationController,
            let albumsTableViewController = navigationController.viewControllers.first as? AlbumsTableViewController
        else {
            return true
        }
        let requestManager = DataFetchManager()
        let configuration = ManagedObjectListConfiguration<AlbumsAPIRequest>(paginationManager: DataPaginationManager(dataFetcher: requestManager), persistentContainer: persistentContainer, requestManager: requestManager, request: AlbumsAPIRequest(with: persistentContainer))
        albumsTableViewController.configure(configuration)
        return true
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "PinchChallenge")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
