//
//  PersistentContainerProvider.swift
//  PinchChallenge
//
//  Created by Feef Anthony on 5/24/20.
//  Copyright © 2020 Feef Anthony. All rights reserved.
//

import CoreData

protocol PersistentContainerProvider {
    var persistentContainer: NSPersistentContainer { get }
}
