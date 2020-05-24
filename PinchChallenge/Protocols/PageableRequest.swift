//
//  PageableRequest.swift
//  PinchChallenge
//
//  Created by Feef Anthony on 5/23/20.
//  Copyright © 2020 Feef Anthony. All rights reserved.
//

import Foundation

private struct Contstants {
    static let pageQueryName = "_page"
}

enum PagwableError: Error {
    case invalidURL(URL?), urlGeneration(URLComponents)
}

protocol PageableRequest: APIRequest {
    var pageSize: UInt { get }
    func urlForPage(_ page: Page) throws -> URL
}

extension PageableRequest {
    func urlForPage(_ page: Page) throws -> URL {
        let pageQueryItem = URLQueryItem(name: Contstants.pageQueryName, value: "\(page.value)")
        guard
            let unwrappedURL = url,
            let components = URLComponents(url: unwrappedURL, resolvingAgainstBaseURL: true)
        else {
            throw PagwableError.invalidURL(url)
        }
        guard let updatedURL = components.appendingQueryItems([pageQueryItem]).url else {
            throw PagwableError.urlGeneration(components)
        }
        return updatedURL
    }
}
