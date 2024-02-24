//
//  ViewController.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.


import UIKit

final class HomeViewController: UIViewController {
    
    // MARK: Type(s)
    
    typealias ContentCellRegistration = UICollectionView.CellRegistration<HomeContentCell, PhotoResource>
    typealias DataSource = UICollectionViewDiffableDataSource<Section, PhotoResource>
    typealias SnapShot = NSDiffableDataSourceSectionSnapshot<PhotoResource>
    
    enum Section {
        case main
    }
    
    // MARK: Property(s)
    
    var viewModel: HomeViewModel?
    
    private var diffableDataSource: DataSource?
    private var snapShot: SnapShot = SnapShot()
    
    private let contentCollectionView: UICollectionView = {
        let collection = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewCompositionalLayout.portraitLayout
        )
        return collection
    }()
    
    private let contentRefreshControl: UIRefreshControl = UIRefreshControl()
    private let paginationFetchControl: PaginationFetchControl = PaginationFetchControl()
    
    // MARK: Override(s)
    
    override func loadView() {
        self.view = contentCollectionView
        self.view.backgroundColor = .systemGray6
        contentCollectionView.refreshControl = contentRefreshControl
        contentCollectionView.dataSource = diffableDataSource
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        configureContentRefreshControl()
        configureDiffableDataSource()
        configurePaginationFetchControl()
        viewModel?.fetchCuratedPhotosPage()
    }
    
    // MARK: Private Function(s)
    
    private func bindViewModel() {
        viewModel?.loadedCuratedPhotos = { [weak self] curatedPhotos in
            guard let self else { return }
            
            let snapShotItems = self.snapShot.items
            let itemsWithoutDuplication = curatedPhotos.filter { !snapShotItems.contains($0) }
            applySnapShot(with: itemsWithoutDuplication)
            
            DispatchQueue.main.async {
                if self.contentRefreshControl.isRefreshing {
                    self.contentRefreshControl.endRefreshing()
                }
            }
        }
    }
    
    private func configureContentRefreshControl() {
        let refreshAction = #selector(didInvokeRefresh)
        contentRefreshControl.addTarget(self, action: refreshAction, for: .valueChanged)
    }
    
    private func configurePaginationFetchControl() {
        paginationFetchControl.configure(scrollView: contentCollectionView)
        paginationFetchControl.didTriggerFetchMore = { [weak self] in
            self?.viewModel?.fetchNextPage()
        }
    }
    
    private func configureDiffableDataSource() {
        let contentCellRegistration = makeContentCellRegistration()
        let diffableDataSource = DataSource(collectionView: contentCollectionView) {
            collectionView, indexPath, viewModel in
            
            collectionView.dequeueConfiguredReusableCell(
                using: contentCellRegistration,
                for: indexPath,
                item: viewModel
            )
        }
        self.diffableDataSource = diffableDataSource
    }
    
    private func makeContentCellRegistration() -> ContentCellRegistration {
        return ContentCellRegistration { cell, indexPath, photoResource in
            let imageURL = photoResource.url["portrait"]!
            let viewModel = HomeContentCellViewModel(
                userName: photoResource.photographer,
                userProfileURL: photoResource.photographerURL,
                imageURL: imageURL
            )
            cell.configure(using: viewModel)
        }
    }
    
    private func applySnapShot(with resources: [PhotoResource]) {
        snapShot.append(resources)
        diffableDataSource?.apply(snapShot, to: .main)
    }
    
    private func resetSnapShot() {
        snapShot.deleteAll()
    }
    
    // MARK: Action(s)
    
    @objc
    private func didInvokeRefresh() {
        resetSnapShot()
        viewModel?.resetPage()
    }
}
