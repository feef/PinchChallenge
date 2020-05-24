//
//  Photo+CoreDataClass.swift
//  
//
//  Created by Feef Anthony on 5/17/20.
//
//

import Foundation
import CoreData

@objc(Photo)
public class Photo: NSManagedObject, Codable {
    private enum CodingKeys: String, CodingKey {
        case id
        case albumId
        case title
        case url
        case thumbnailUrl
        case thumbnailData
        case imageData
    }
    
    // MARK: - Decodable
    
    public required convenience init(from decoder: Decoder) throws {
        guard
            let context = decoder.userInfo[.context] as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: "Photo", in: context)
        else {
            fatalError()
        }

        self.init(entity: entity, insertInto: context)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int32.self, forKey: .id)
        albumId = try container.decode(Int32.self, forKey: .albumId)
        title = try container.decode(String.self, forKey: .title)
        url = try container.decode(URL.self, forKey: .url)
        thumbnailUrl = try container.decode(URL.self, forKey: .thumbnailUrl)
        thumbnailData = try container.decodeIfPresent(Data.self, forKey: .thumbnailData)
        imageData = try container.decodeIfPresent(Data.self, forKey: .imageData)
    }
    
    // MARK: - Encodable
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(albumId, forKey: .albumId)
        try container.encode(title, forKey: .title)
        try container.encode(url, forKey: .url)
        try container.encode(thumbnailUrl, forKey: .thumbnailUrl)
        try container.encodeIfPresent(thumbnailData, forKey: .thumbnailData)
        try container.encodeIfPresent(imageData, forKey: .imageData)
    }
}
