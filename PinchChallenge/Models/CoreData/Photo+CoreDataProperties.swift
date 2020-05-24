//
//  Photo+CoreDataProperties.swift
//  PinchChallenge
//
//  Created by Feef Anthony on 5/21/20.
//  Copyright © 2020 Feef Anthony. All rights reserved.
//
//

import Foundation
import CoreData


extension Photo {

    @nonobjc public class func fetchRequest(albumId: Int32? = nil) -> NSFetchRequest<Photo> {
        let fetchRequest = NSFetchRequest<Photo>(entityName: "Photo")
        if let albumId = albumId {
            fetchRequest.predicate = NSPredicate(format: "albumId == %d", albumId)
        }
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        return fetchRequest
    }

    @NSManaged public var albumId: Int32
    @NSManaged public var id: Int32
    @NSManaged public var thumbnailUrl: URL
    @NSManaged public var title: String
    @NSManaged public var url: URL
    @NSManaged public var thumbnailData: Data?
    @NSManaged public var imageData: Data?
    @NSManaged public var album: Album?

}
