//
//  AlbumTests.swift
//  PinchChallengeTests
//
//  Created by Feef Anthony on 5/24/20.
//  Copyright © 2020 Feef Anthony. All rights reserved.
//

import XCTest
import CoreData
@testable import PinchChallenge

class AlbumTests: XCTestCase {
    var context: NSManagedObjectContext!
    
    override func setUp() {
        context = UnitTestHelpers.setUpInMemoryManagedObjectContext()
    }
    
    override func tearDown() {
        context = nil
    }
    
    func testParsingFromAPIResponse() {
        guard let album: Album = ManagedObjectTestHelper.loadModelFromFile(named: "Album", in: context) else {
            return
        }
        XCTAssertEqual(album.userId, 123)
        XCTAssertEqual(album.id, 456)
        XCTAssertEqual(album.title, "album title value")
    }
}
