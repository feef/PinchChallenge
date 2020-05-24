//
//  TestDataFetcher.swift
//  PinchChallengeTests
//
//  Created by Feef Anthony on 5/24/20.
//  Copyright © 2020 Feef Anthony. All rights reserved.
//

import Foundation
import RxSwift
@testable import PinchChallenge

enum Endpoint: String {
    case thumbnailImage = "https://www.thumbnailValue.com"
    case fullsizeImage = "https://www.urlValue.com"
    
    var url: URL! {
        return URL(string: rawValue)!
    }
    
    var data: Data {
        switch self {
            case .fullsizeImage:
                return UIImage(named: "fullSize.png", in: Bundle(for: TestDataFetcher.self), with: nil)!.pngData()!
            case .thumbnailImage:
                return UIImage(named: "thumbnail.png", in: Bundle(for: TestDataFetcher.self), with: nil)!.pngData()!
        }
    }
}

class TestDataFetcher: DataFetcher {
    func fetchData(from url: URL) -> Single<Data> {
        Single<Data>.create { single in
            single(.success(Endpoint(rawValue: url.absoluteString)!.data))
            return Disposables.create()
        }
    }
}
