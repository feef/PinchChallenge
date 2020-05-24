//
//  APIRequest.swift
//  PinchChallenge
//
//  Created by Feef Anthony on 5/21/20.
//  Copyright © 2020 Feef Anthony. All rights reserved.
//

import RxSwift

protocol APIRequest {
    associatedtype Result
    
    var url: URL? { get }
    func parse(_ data: Data) throws -> Result
}
