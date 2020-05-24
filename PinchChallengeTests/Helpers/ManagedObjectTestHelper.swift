//
//  ManagedObjectTestHelper.swift
//  PinchChallengeTests
//
//  Created by Feef Anthony on 5/24/20.
//  Copyright © 2020 Feef Anthony. All rights reserved.
//

import CoreData
import XCTest
@testable import PinchChallenge

class ManagedObjectTestHelper {
    @discardableResult static func loadModelFromFile<Model: NSManagedObject & Decodable>(named fileName: String, in context: NSManagedObjectContext) -> Model? {
        guard let data = try? FileReader.jsonDataFromFile(named: fileName) else {
            XCTFail("Testing data expected named \(fileName) is missing")
            return nil
        }
        do {
            let decoder = JSONDecoder()
            decoder.userInfo[.context] = context
            return try decoder.decode(Model.self, from: data)
        }
        catch {
            guard let stringedData = String(data: data, encoding: .utf8) else {
                XCTFail("Failed to initialize photo from file named: \(fileName)")
                return nil
            }
            XCTFail("Failed to initialize photo from payload: \(stringedData)\n\nfrom file named: \(fileName)")
            return nil
        }

    }
}
