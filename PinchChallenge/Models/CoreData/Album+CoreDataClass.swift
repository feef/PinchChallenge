//
//  Album+CoreDataClass.swift
//  
//
//  Created by Feef Anthony on 5/17/20.
//
//

import Foundation
import CoreData

@objc(Album)
public class Album: NSManagedObject, Codable {
    private enum CodingKeys: String, CodingKey {
        case id
        case userId
        case title
    }
    
    // MARK: - Decodable
    
    public required convenience init(from decoder: Decoder) throws {
        guard
            let context = decoder.userInfo[.context] as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: "Album", in: context)
        else {
            fatalError()
        }

        self.init(entity: entity, insertInto: context)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int32.self, forKey: .id)
        userId = try container.decode(Int32.self, forKey: .userId)
        title = try container.decodeIfPresent(String.self, forKey: .title)
    }
    
    // MARK: - Encodable
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(userId, forKey: .userId)
        try container.encode(title, forKey: .title)
    }
}
