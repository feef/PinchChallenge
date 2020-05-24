//
//  ImageFetchManagerTests.swift
//  PinchChallengeTests
//
//  Created by Feef Anthony on 5/24/20.
//  Copyright © 2020 Feef Anthony. All rights reserved.
//

import XCTest
import CoreData
import RxSwift
@testable import PinchChallenge

class ImageFetchManagerTests: XCTestCase {
    var context: NSManagedObjectContext!
    
    override func setUp() {
        context = UnitTestHelpers.setUpInMemoryManagedObjectContext()
    }
    
    override func tearDown() {
        context = nil
    }
    
    func testThumbnailImageFetch() {
        let imageFetchManager = ImageFetchManager()
        guard let photo: Photo = ManagedObjectTestHelper.loadModelFromFile(named: "Photo", in: context) else {
            XCTFail("Failed to load photo for ImageFetchManagerTests testThumbnailImageFetch")
            return
        }
        imageFetchManager.fetchAndSaveImage(for: photo, withSize: .thumbnail, using: TestDataFetcher()).subscribe { event in
            guard case .next(let updatedPhoto) = event else {
                return
            }
            XCTAssertEqual(updatedPhoto.thumbnailData, Endpoint.thumbnailImage.data)
        }
        .disposed(by: DisposeBag())
    }

    func testFullSizeImageFetch() {
        let imageFetchManager = ImageFetchManager()
        guard let photo: Photo = ManagedObjectTestHelper.loadModelFromFile(named: "Photo", in: context) else {
            XCTFail("Failed to load photo for ImageFetchManagerTests testFullSizeImageFetch")
            return
        }
        imageFetchManager.fetchAndSaveImage(for: photo, withSize: .full, using: TestDataFetcher()).subscribe { event in
            guard case .next(let updatedPhoto) = event else {
                return
            }
            XCTAssertEqual(updatedPhoto.imageData, Endpoint.fullsizeImage.data)
        }
        .disposed(by: DisposeBag())
    }
}
