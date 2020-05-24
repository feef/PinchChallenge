//
//  DataPaginationManager.swift
//  PinchChallenge
//
//  Created by Feef Anthony on 5/21/20.
//  Copyright © 2020 Feef Anthony. All rights reserved.
//

import RxSwift

class DataPaginationManager: DataPaginator {
    private let disposeBag = DisposeBag()
    private let nextPageToLoad = BehaviorSubject<Page>(value: .first)
    private let dataFetcher: DataFetcher
        
    required init(dataFetcher: DataFetcher) {
        self.dataFetcher = dataFetcher
    }
}

// MARK: - Fetching

extension DataPaginationManager {
    func setNextPage<Request: ManagedObjectAPIRequest & PageableRequest>(using request: Request) -> Page {
        let existingObjectsCount = (try? request.persistentContainer.viewContext.count(for: request.fetchRequest)) ?? 0
        let offset = UInt(existingObjectsCount) / request.pageSize
        let updatedPage = Page.first + offset
        nextPageToLoad.onNext(updatedPage)
        return updatedPage
    }
    
    // Suspect this could be cleaner
    func fetch<Request: PageableRequest>(page: Page, of request: Request) -> Single<Request.Result> {
        nextPageToLoad.onNext(page)
        return Single<Request.Result>.create { single in
            do {
                let pagedURL = try request.urlForPage(page)
                return self.dataFetcher.fetchData(from: pagedURL)
                    .map(request.parse)
                    .subscribe { event in
                        switch event {
                            case .success(let result):
                                self.nextPageToLoad.onNext(page + 1)
                                single(.success(result))
                            case .error(let error):
                                single(.error(error))
                        }
                    }
            }
            catch let error {
                single(.error(error))
                return Disposables.create()
            }
        }
    }

    func fetchNextPage<Request: PageableRequest>(using request: Request) -> Single<Request.Result> {
        return Single<Request.Result>.create { single in
            do {
                let page = try self.nextPageToLoad.value()
                return self.fetch(page: page, of: request).subscribe(single)
            }
            catch let error {
                single(.error(error))
                return Disposables.create()
            }
        }
    }
}
