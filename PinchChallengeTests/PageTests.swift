//
//  PageTests.swift
//  PinchChallengeTests
//
//  Created by Feef Anthony on 5/24/20.
//  Copyright © 2020 Feef Anthony. All rights reserved.
//

import XCTest
@testable import PinchChallenge

class PageTests: XCTestCase {
    func testFirstPageValue() {
        XCTAssertEqual(Page.first.value, 1)
    }
    
    func testAddition() {
        XCTAssertEqual((Page.first + 2).value, 3)
    }
    
    func testSubtraction() {
        let page6 = Page.first + 5
        XCTAssertEqual((page6 - 4).value, 2)
        XCTAssertEqual((page6 - 10).value, 1)
    }
}
