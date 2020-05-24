//
//  AlbumsTableViewController.swift
//  PinchChallenge
//
//  Created by Feef Anthony on 5/16/20.
//  Copyright © 2020 Feef Anthony. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import CoreData

private struct Constants {
    struct Localized {
        static let albums = "Albums"
    }
    
    // Must match interface file
    struct Interface {
        static let cellReuseIdentifier = "albumCell"
        static let showPhotosSegueIdentifier = "showPhotos"
    }
}

class AlbumsTableViewController: ManagedObjectListViewController<AlbumsAPIRequest> {
    typealias RequestBuilderType = AlbumsAPIRequest

    private let disposeBag = DisposeBag()
    
    private var selectedAlbum: RequestBuilderType.ManagedObject?
    
    // MARK: - Init
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        title = Constants.Localized.albums
    }
}

// MARK: - Lifecycle

extension AlbumsTableViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        selectedAlbum = nil
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
            .modelSelected(Album.self)
            .bind { [weak self] album in
                self?.selectedAlbum = album
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
            let albumId = selectedAlbum?.id,
            let photosViewController = segue.destination as? PhotosTableViewController
        else {
            return
        }
        var request = PhotosAPIRequest(with: persistentContainer)
        request.albumId = albumId
        let configuration = ManagedObjectListConfiguration<PhotosAPIRequest>(paginationManager: DataPaginationManager(dataFetcher: requestManager), persistentContainer: persistentContainer, requestManager: requestManager, request: request)
        photosViewController.configure(configuration)
    }
}
