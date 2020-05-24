//
//  FileReader.swift
//  PinchChallengeTests
//
//  Created by Feef Anthony on 5/24/20.
//  Copyright © 2020 Feef Anthony. All rights reserved.
//

import Foundation

class FileReader {
    static func jsonDataFromFile(named fileName: String) throws -> Data {
        for bundle in Bundle.allBundles {
            if let filePath = bundle.path(forResource: fileName, ofType: "json") {
                return try jsonDataFromFile(atPath: filePath)
            }
        }
        throw FileReadError.unableToFindFileNamed(fileName)
    }
    
    static func jsonDataFromFile(atPath path: String) throws -> Data {
        guard let data = FileManager.default.contents(atPath: path) else {
            throw FileReadError.unableToFindFileAtPath(path)
        }
        return data
    }
}
