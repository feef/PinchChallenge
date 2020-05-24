//
//  PhotosAPIRequest.swift
//  PinchChallenge
//
//  Created by Feef Anthony on 5/21/20.
//  Copyright © 2020 Feef Anthony. All rights reserved.
//

import CoreData

struct PhotosAPIRequest: ManagedObjectAPIRequest, PageableRequest {
    private struct Constants {
        static let path = "photos"
        static let albumIdQueryKey = "albumId"
        static let pageSize: UInt = 10
    }
    
    typealias ManagedObject = Photo
    typealias Result = [ManagedObject]
    
    var url: URL? {
        guard
            let photoURL = URL(string: Constants.path, relativeTo: .pinch),
            let albumId = albumId
        else {
            return nil
        }
        let components = URLComponents(url: photoURL, resolvingAgainstBaseURL: true)
        let albumQueryItem = URLQueryItem(name: Constants.albumIdQueryKey, value: "\(albumId)")
        return components?.appendingQueryItems([albumQueryItem]).url
    }
    let persistentContainer: NSPersistentContainer
    var fetchRequest: NSFetchRequest<ManagedObject> {
        return Photo.fetchRequest(albumId: albumId)
    }
    var deleteRequest: NSBatchDeleteRequest {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = self.fetchRequest as! NSFetchRequest<NSFetchRequestResult>
        return NSBatchDeleteRequest(fetchRequest: fetchRequest)
    }
    let pageSize = Constants.pageSize
    var albumId: Int32?
    
    init(with persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
    }
}
