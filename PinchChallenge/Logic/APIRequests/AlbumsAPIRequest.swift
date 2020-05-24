//
//  AlbumsAPIRequest.swift
//  PinchChallenge
//
//  Created by Feef Anthony on 5/21/20.
//  Copyright © 2020 Feef Anthony. All rights reserved.
//

import CoreData

struct AlbumsAPIRequest: ManagedObjectAPIRequest, PageableRequest {
    private struct Constants {
        static let path = "albums"
        static let pageSize: UInt = 10
    }
    
    typealias ManagedObject = Album
    typealias Result = [ManagedObject]
    
    let pageSize: UInt = Constants.pageSize
    let url = URL(string: Constants.path, relativeTo: .pinch)
    let persistentContainer: NSPersistentContainer
    let fetchRequest: NSFetchRequest<ManagedObject> = ManagedObject.fetchRequest()
    
    func deleteRequests(in context: NSManagedObjectContext) throws -> [NSBatchDeleteRequest] {
        let allAlbums = try context.fetch(fetchRequest)
        var (photoDeleteRequests, albumObjectIds) = ([NSBatchDeleteRequest](), [NSManagedObjectID]())
        for album in allAlbums {
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: Photo.fetchRequest(albumId: album.id) as! NSFetchRequest<NSFetchRequestResult>)
            photoDeleteRequests.append(batchDeleteRequest)
            albumObjectIds.append(album.objectID)
        }
        return photoDeleteRequests + [NSBatchDeleteRequest(objectIDs: albumObjectIds)]
    }
    
    init(with persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
    }
}
