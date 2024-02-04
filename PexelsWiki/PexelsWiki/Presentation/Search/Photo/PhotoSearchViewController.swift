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
        viewModel?.fetchSearchResults()
        configureNavigationItem()
        configurePaginationFetchControl()
    }
    
    // MARK: Private Function(s)
    
    private func bindViewModel() {
        guard let viewModel else { return }
        
        viewModel.loadedPhotoContentCellViewModels = { [weak self] photoResources in
            guard let self else { return }
            let snapShotItems = self.snapShot.items
            let itemsWithoutDuplications = photoResources.filter { !snapShotItems.contains($0) }
            self.updateSnapShot(using: itemsWithoutDuplications)
        }
        
        viewModel.didSelectFilterOptions = { [weak self] filterOptions in
            guard let self else { return }
            self.resetSnapShot()
            self.switchContentOrientation(filterOptions.orientation)
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
        let filterButtonItem = UIBarButtonItem(
            image: .init(systemName: "line.3.horizontal.decrease.circle"),
            style: .plain,
            target: self,
            action: #selector(didTapFilterButton)
        )
        navigationItem.rightBarButtonItem = filterButtonItem
        navigationItem.title = viewModel?.query
    }
    
    private func configurePaginationFetchControl() {
        paginationFetchControl.configure(scrollView: photoCollectionView)
        paginationFetchControl.didTriggerFetchMore = { [weak self] in
            self?.viewModel?.fetchNextPage()
        }
    }
    
    private func switchContentOrientation(_ orientation: ContentOrientation) {
        switch orientation {
        case .landscape: photoCollectionView.setCollectionViewLayout(
            UICollectionViewCompositionalLayout.landscapeLayout,
            animated: true
        )
        case .portrait: photoCollectionView.setCollectionViewLayout(
            UICollectionViewCompositionalLayout.portraitLayout,
            animated: true
        )
        case .square: photoCollectionView.setCollectionViewLayout(
            UICollectionViewCompositionalLayout.squareLayout,
            animated: true
        )
        }
        viewModel?.resetPage()
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
    
    private func resetSnapShot() {
        snapShot.deleteAll()
    }
    
    // MARK: Action(s)
    
    @objc private func didTapFilterButton() {
        guard let viewModel else { return }
        delegate?.didTapFilterButton(viewModel.currentFilterOptions())
    }
}
