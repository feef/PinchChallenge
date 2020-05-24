//
//  PhotoDetailViewController.swift
//  PinchChallenge
//
//  Created by Feef Anthony on 5/17/20.
//  Copyright © 2020 Feef Anthony. All rights reserved.
//

import UIKit
import CoreData
import RxSwift

class PhotoDetailViewController: UIViewController {
    private struct Constants {
        struct Localized {
            static let photoDetail = "Photo detail"
        }
    }
    
    struct Configuration {
        let persistentContainer: NSPersistentContainer
        let requestManager: DataFetcher
        let photo: Photo
    }
    
    private let disposeBag = DisposeBag()
    
    private(set) var persistentContainer: NSPersistentContainer!
    private(set) var photo: Photo!
    private(set) var requestManager: DataFetcher!
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var label: UILabel!
    
    // MARK: - Init
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        title = Constants.Localized.photoDetail
    }
    
    func configure(with configuration: Configuration) {
        persistentContainer = configuration.persistentContainer
        photo = configuration.photo
        requestManager = configuration.requestManager
    }
}

// MARK: - Lifecycle

extension PhotoDetailViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        label.text = photo.title
        guard let data = photo.imageData else {
            ImageFetchManager()
                .fetchAndSaveImage(for: photo, withSize: .full, using: self.requestManager)
                .observeOn(MainScheduler.asyncInstance)
                .subscribe(onNext: { photo in
                self.imageView.image = UIImage(data: photo.imageData ?? Data())
            })
            .disposed(by: disposeBag)
            return
        }
        imageView.image = UIImage(data: data)
    }
}


