//
//  ManagedObjectListViewController.swift
//  PinchChallenge
//
//  Created by Feef Anthony on 5/24/20.
//  Copyright © 2020 Feef Anthony. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import CoreData

private struct Constants {
    struct Localized {
        static let loadMore = "Load more"
    }
}

class ManagedObjectListConfiguration<RequestBuilderType> {
    let paginationManager: DataPaginator
    let persistentContainer: NSPersistentContainer
    let requestManager: DataFetcher
    let request: RequestBuilderType
    
    init(paginationManager: DataPaginator, persistentContainer: NSPersistentContainer, requestManager: DataFetcher, request: RequestBuilderType) {
        self.paginationManager = paginationManager
        self.persistentContainer = persistentContainer
        self.requestManager = requestManager
        self.request = request
    }
}

class ManagedObjectListViewController<RequestBuilderType: ManagedObjectAPIRequest & PageableRequest>: UITableViewController {
    
    private let disposeBag = DisposeBag()
    
    @IBOutlet private var loadMoreButton: UIBarButtonItem! {
        didSet {
            loadMoreButton.title = Constants.Localized.loadMore
        }
    }
    
    private(set) var request: RequestBuilderType! {
        didSet {
            let objects = try? persistentContainer.viewContext.fetch(request.fetchRequest)
            items = BehaviorRelay<RequestBuilderType.Result>(value: objects ?? [])
        }
    }
    private(set) var persistentContainer: NSPersistentContainer!
    private(set) var paginationManager: DataPaginator!
    private(set) var requestManager: DataFetcher!
    private(set) var items: BehaviorRelay<RequestBuilderType.Result>!
    
    private var selectedItem: RequestBuilderType.Result.Element?
    
    // MARK: - Init
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configure(_ configuration: ManagedObjectListConfiguration<RequestBuilderType>) {
        let persistentContainer = configuration.persistentContainer
        self.persistentContainer = persistentContainer
        self.paginationManager = configuration.paginationManager
        self.request = configuration.request
        self.requestManager = configuration.requestManager
    }

    // MARK: - Lifecycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        selectedItem = nil
    }
    
    // MARK: - Data management

    @IBAction func refresh() {
        guard refreshControl?.isRefreshing == true else {
            return
        }
        let context = persistentContainer.newBackgroundContext()
        do {
            let batchDeleteRequests = try request.deleteRequests(in: context)
            try batchDeleteRequests.forEach { try context.executeAndMergeChanges(using: $0) }
            try context.save()
        }
        catch let error {
            // TODO: Implement error handling
            print(error)
            return
        }
        items.accept([])
        fetchFirstPage()
    }
    
    func addSubscription(to paginationRequest: Single<RequestBuilderType.Result>) {
        paginationRequest
            .observeOn(MainScheduler.asyncInstance)
            .subscribe { event in
                if self.refreshControl?.isRefreshing == true {
                    self.refreshControl?.endRefreshing()
                }
                switch event {
                    case .success(let result):
                        self.items.accept(self.items.value + result)
                    case .error(let error):
                        // TODO: Add retry / error support
                        print(error)
                }
            }
            .disposed(by: disposeBag)
    }
    
    func fetchFirstPage() {
       addSubscription(to: paginationManager.fetch(page: .first, of: request))
    }
    
    @IBAction func fetchNextPage() {
        addSubscription(to: paginationManager.fetchNextPage(using: request))
    }
}
