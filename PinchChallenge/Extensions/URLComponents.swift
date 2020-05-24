//
//  URLComponents.swift
//  PinchChallenge
//
//  Created by Feef Anthony on 5/24/20.
//  Copyright © 2020 Feef Anthony. All rights reserved.
//

import Foundation

extension URLComponents {
    func appendingQueryItems(_ urlQueryItems: [URLQueryItem]) -> URLComponents {
        var updatedComponents = self
        var updatedQueryItems = updatedComponents.queryItems ?? [URLQueryItem]()
        urlQueryItems.forEach { updatedQueryItems.append($0) }
        updatedComponents.queryItems = updatedQueryItems
        return updatedComponents
    }
}
