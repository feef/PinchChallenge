//
//  FileReadError.swift
//  PinchChallengeTests
//
//  Created by Feef Anthony on 5/24/20.
//  Copyright © 2020 Feef Anthony. All rights reserved.
//

import Foundation

public enum FileReadError: LocalizedError {
    case unableToFindFileNamed(String), unableToFindFileAtPath(String)
}
