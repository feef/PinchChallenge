//
//  DataPaginator.swift
//  PinchChallenge
//
//  Created by Feef Anthony on 5/21/20.
//  Copyright © 2020 Feef Anthony. All rights reserved.
//

import RxSwift

protocol DataPaginator {
    init(dataFetcher: DataFetcher)
    
    func setNextPage<Request: ManagedObjectAPIRequest & PageableRequest>(using request: Request) -> Page
    func fetchNextPage<Request: PageableRequest>(using request: Request) -> Single<Request.Result>
    func fetch<Request: PageableRequest>(page: Page, of request: Request) -> Single<Request.Result>
}
