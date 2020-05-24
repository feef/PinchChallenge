//
//  ManagedObjectAPIRequest.swift
//  PinchChallenge
//
//  Created by Feef Anthony on 5/22/20.
//  Copyright © 2020 Feef Anthony. All rights reserved.
//

import CoreData
import RxSwift

protocol ManagedObjectAPIRequest: APIRequest where Result == [ManagedObject] {
    associatedtype ManagedObject: NSManagedObject & Codable
    var persistentContainer: NSPersistentContainer { get }
    var fetchRequest: NSFetchRequest<ManagedObject> { get }
    
    func deleteRequests(in context: NSManagedObjectContext) throws -> [NSBatchDeleteRequest]
    func parseAndSaveManagedObjects(from data: Data) throws -> Result
}

extension ManagedObjectAPIRequest {
    func deleteRequests(in context: NSManagedObjectContext) throws -> [NSBatchDeleteRequest] {
        let fetchRequest = self.fetchRequest as! NSFetchRequest<NSFetchRequestResult>
        return [NSBatchDeleteRequest(fetchRequest: fetchRequest)]
    }
    
    func parseAndSaveManagedObjects(from data: Data) throws -> Result {
        let context = persistentContainer.viewContext
        context.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        let decoder = JSONDecoder()
        decoder.userInfo[.context] = context
        let objects = try decoder.decode([ManagedObject].self, from: data)
        try context.save()
        return objects
    }
    
    func parse(_ data: Data) throws -> Result {
        return try parseAndSaveManagedObjects(from: data)
    }
}
