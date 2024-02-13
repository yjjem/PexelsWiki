//
//  ImageSearchViewController.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.


import UIKit

protocol PhotoSearchViewControllerDelegate: AnyObject {
    func didTapFilterButton(_ currentOptions: FilterOptions)
}

final class PhotoSearchViewController: UIViewController {
    
    // MARK: Type(s)
    
    typealias PhotoContentCellRegistartion = UICollectionView.CellRegistration<PhotoContentCell, PhotoContentCellViewModel>
    typealias DataSource = UICollectionViewDiffableDataSource<Section, PhotoContentCellViewModel>
    typealias SnapShot = NSDiffableDataSourceSectionSnapshot<PhotoContentCellViewModel>
    
    enum Section {
        case main
    }
    
    // MARK: Variable(s)
    
    var viewModel: PhotoSearchViewModel?
    weak var delegate: PhotoSearchViewControllerDelegate?
    
    private var diffableDataSource: DataSource?
    private var snapShot: SnapShot = SnapShot()
    
    private let paginationFetchControl: PaginationFetchControl = PaginationFetchControl()
    private let photoCollectionView: UICollectionView = {
        let collection = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewCompositionalLayout.landscapeLayout
        )
        return collection
    }()
    
    // MARK: Override(s)
    
    override func loadView() {
        self.view = photoCollectionView
        photoCollectionView.dataSource = diffableDataSource
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        configureDiffableDataSource()
        configureNavigationItem()
        configurePaginationFetchControl()
        viewModel?.fetchSearchResults()
    }
    
    // MARK: Private Function(s)
    
    private func bindViewModel() {
        viewModel?.loadedPhotoContentCellViewModels = { [weak self] photoResources in
            guard let self else { return }
            let snapShotItems = self.snapShot.items
            let itemsWithoutDuplications = photoResources.filter { !snapShotItems.contains($0) }
            self.updateSnapShot(using: itemsWithoutDuplications)
        }
    }
    
    private func configureDiffableDataSource() {
        let photoContentCellRegistration = makePhotoContentCellRegistration()
        let diffableDataSource = DataSource(collectionView: photoCollectionView) {
            collectionView, indexPath, itemIdentifier in
            
            collectionView.dequeueConfiguredReusableCell(
                using: photoContentCellRegistration,
                for: indexPath,
                item: itemIdentifier
            )
        }
        self.diffableDataSource = diffableDataSource
    }
    
    private func configureNavigationItem() {
        navigationItem.title = viewModel?.query
    }
    
    private func configurePaginationFetchControl() {
        paginationFetchControl.configure(scrollView: photoCollectionView)
        paginationFetchControl.didTriggerFetchMore = { [weak self] in
            self?.viewModel?.fetchNextPage()
        }
    }
    
    private func makePhotoContentCellRegistration() -> PhotoContentCellRegistartion {
        return PhotoContentCellRegistartion { cell, indexPath, cellViewModel in
            cell.configure(using: cellViewModel)
        }
    }
    
    private func updateSnapShot(using photoList: [PhotoContentCellViewModel]) {
        snapShot.append(photoList)
        diffableDataSource?.apply(snapShot, to: .main)
    }
    
    
    }
}
