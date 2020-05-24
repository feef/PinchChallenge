//
//  PhotoTests.swift
//  PinchChallengeTests
//
//  Created by Feef Anthony on 5/24/20.
//  Copyright © 2020 Feef Anthony. All rights reserved.
//

import Foundation
import XCTest
import CoreData
@testable import PinchChallenge

class PhotoTests: XCTestCase {
    var context: NSManagedObjectContext!
    
    override func setUp() {
        context = UnitTestHelpers.setUpInMemoryManagedObjectContext()
    }
    
    override func tearDown() {
        context = nil
    }
    
    func testParsingFromAPIResponse() {
        guard let photo: Photo = ManagedObjectTestHelper.loadModelFromFile(named: "Photo", in: context) else {
            return
        }
        XCTAssertEqual(photo.albumId, 123)
        XCTAssertEqual(photo.id, 456)
        XCTAssertEqual(photo.title, "photo title value")
        XCTAssertEqual(photo.thumbnailUrl, URL(string: "https://www.thumbnailValue.com"))
        XCTAssertEqual(photo.url, URL(string: "https://www.urlValue.com"))
    }
}
