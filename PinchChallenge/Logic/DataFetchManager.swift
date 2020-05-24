//
//  DataFetchManager.swift
//  PinchChallenge
//
//  Created by Feef Anthony on 5/17/20.
//  Copyright © 2020 Feef Anthony. All rights reserved.
//

import RxSwift

class DataFetchManager: DataFetcher {
    enum FetchError: Error {
        case unknown(URLResponse?)
    }
    
    func fetchData(from url: URL) -> Single<Data> {
        return Single<Data>.create { single in
            let task = URLSession.shared.dataTask(with: url, completionHandler: { data, urlResponse, error in
                guard let data = data else {
                    single(.error(error ?? FetchError.unknown(urlResponse)))
                    return
                }
                single(.success(data))
            })
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
}
