//
//  DataFetcher.swift
//  PinchChallenge
//
//  Created by Feef Anthony on 5/17/20.
//  Copyright © 2020 Feef Anthony. All rights reserved.
//

import RxSwift

protocol DataFetcher {
    func fetchData(from url: URL) -> Single<Data>
}
