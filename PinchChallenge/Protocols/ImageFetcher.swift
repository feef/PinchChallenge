//
//  ImageFetcher.swift
//  PinchChallenge
//
//  Created by Feef Anthony on 5/24/20.
//  Copyright © 2020 Feef Anthony. All rights reserved.
//

import RxSwift

protocol ImageFetcher {
    func fetchAndSaveImage(for photo: Photo, withSize size: ImageSize, using requestManager: DataFetcher) -> Observable<Photo>
}
