//
//  UITableViewCellPopulator.swift
//  PinchChallenge
//
//  Created by Feef Anthony on 5/24/20.
//  Copyright © 2020 Feef Anthony. All rights reserved.
//

import UIKit

struct UITableViewCellPopualator {
    static func populate(_ cell: UITableViewCell, with managedObject: AlbumsAPIRequest.ManagedObject) {
        cell.textLabel?.text = managedObject.title
    }
    
    static func populate(_ cell: UITableViewCell, with managedObject: PhotosAPIRequest.ManagedObject) {
        cell.textLabel?.text = managedObject.title
        cell.imageView?.image = UIImage(data: managedObject.thumbnailData ?? Data())
    }
}

