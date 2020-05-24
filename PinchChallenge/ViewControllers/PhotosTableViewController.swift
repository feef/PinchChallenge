//
//  PhotosTableViewController.swift
//  PinchChallenge
//
//  Created by Feef Anthony on 5/21/20.
//  Copyright © 2020 Feef Anthony. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import CoreData

private struct Constants {
    struct Localized {
        static let photos = "Photos"
    }
    
    // Must match interface file
    struct Interface {
        static let cellReuseIdentifier = "photoCell"
        static let showPhotosSegueIdentifier = "showPhotoDetail"
    }
}

class PhotosTableViewController: ManagedObjectListViewController<PhotosAPIRequest> {
    typealias RequestBuilderType = PhotosAPIRequest
    
    private let disposeBag = DisposeBag()
    
    private var selectedItem: RequestBuilderType.Result.Element?
    
    // MARK: - Init
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        title = Constants.Localized.photos
    }
    
    // MARK: - Data management

    override func addSubscription(to paginationRequest: PrimitiveSequence<SingleTrait, [PhotosAPIRequest.ManagedObject]>) {
        let imageFetcher = ImageFetchManager()
        paginationRequest.subscribe(onSuccess: { photos in
            Observable
                .zip(photos.map { imageFetcher.fetchAndSaveImage(for: $0, withSize: .thumbnail, using: self.requestManager) })
                .observeOn(MainScheduler.asyncInstance)
                .subscribe(onNext: { photos in
                    try? self.persistentContainer.viewContext.save()
                    self.items.accept(self.items.value + photos)
                    guard self.refreshControl?.isRefreshing == true else {
                        return
                    }
                    self.refreshControl?.endRefreshing()
                })
                .disposed(by: self.disposeBag)
        })
        .disposed(by: self.disposeBag)
    }
}

// MARK: - Lifecycle

extension PhotosTableViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        selectedItem = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = nil
        tableView.dataSource = nil
        
        items
            .distinctUntilChanged()
            .bind(to: tableView.rx.items(cellIdentifier: Constants.Interface.cellReuseIdentifier)) { (_, managedObject, cell) in
                UITableViewCellPopualator.populate(cell, with: managedObject)
            }
            .disposed(by: disposeBag)
        
        tableView.rx
            .modelSelected(RequestBuilderType.Result.Element.self)
            .bind { [weak self] item in
                self?.selectedItem = item
                self?.performSegue(withIdentifier: Constants.Interface.showPhotosSegueIdentifier, sender: self)
            }
            .disposed(by: disposeBag)
        
        let nextPage = paginationManager.setNextPage(using: request)
        guard nextPage == .first else {
            return
        }
        fetchFirstPage()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            let photo = selectedItem,
            let photoDetailViewController = segue.destination as? PhotoDetailViewController
        else {
            return
        }
        let configure = PhotoDetailViewController.Configuration(persistentContainer: persistentContainer, requestManager: DataFetchManager(), photo: photo)
        photoDetailViewController.configure(with: configure)
    }
}
