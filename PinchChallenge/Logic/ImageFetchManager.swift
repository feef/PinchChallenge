//
//  ImageFetchManager.swift
//  PinchChallenge
//
//  Created by Feef Anthony on 5/24/20.
//  Copyright © 2020 Feef Anthony. All rights reserved.
//

import RxSwift

class ImageFetchManager: ImageFetcher {
    func fetchAndSaveImage(for photo: Photo, withSize size: ImageSize, using requestManager: DataFetcher) -> Observable<Photo> {
        let url: URL
        switch size {
            case .thumbnail:
                url = photo.thumbnailUrl
            case .full:
                url = photo.url
        }
        return Observable.create { observer in
            return requestManager.fetchData(from: url).subscribe(onSuccess: { data in
                switch size {
                    case .thumbnail:
                        photo.thumbnailData = data
                    case .full:
                        photo.imageData = data
                }
                return observer.onNext(photo)
            })
        }.retry(3)
    }
}
