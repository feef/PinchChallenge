//
//  Page.swift
//  PinchChallenge
//
//  Created by Feef Anthony on 5/21/20.
//  Copyright © 2020 Feef Anthony. All rights reserved.
//

import Foundation

struct Page: Equatable {
    static let first = Page(value: 1)
    
    let value: UInt
    
    private init(value: UInt) {
        self.value = value
    }
}

extension Page {
    static func +(page: Page, offset: UInt) -> Page {
        return Page(value: page.value + offset)
    }
    
    static func -(page: Page, offset: UInt) -> Page {
        let invalidOffset = offset > page.value - Page.first.value
        return invalidOffset ? .first : Page(value: page.value - offset)
    }
}
