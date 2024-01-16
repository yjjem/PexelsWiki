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
    
    private let photoCollectionView: UICollectionView = {
        let collection = UICollectionView(
            frame: .zero,
            collectionViewLayout: .init()
        )
        return collection
    }()
    
    private let paginationFetchControl: PaginationFetchControl = PaginationFetchControl()
    
    // MARK: Override(s)
    
    override func loadView() {
        super.loadView()
        
        configureNavigationItem()
        configurePhotoCollectionView()
        configurePaginationFetchControl()
        
        if let viewModel {
            addNavigationTitle(viewModel.query)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel?.fetchSearchResults()
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
            viewModel.resetPage()
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
    }
    
    private func addNavigationTitle(_ title: String) {
        navigationItem.title = title
    }
    
    private func configureNavigationItem() {
        let filterButtonItem = UIBarButtonItem(
            image: .init(systemName: "line.3.horizontal.decrease.circle"),
            style: .plain,
            target: self,
            action: #selector(didTapFilterButton)
        )
        navigationItem.rightBarButtonItem = filterButtonItem
    }
    
    private func configurePhotoCollectionView() {
        diffableDataSource = makeDiffableDataSource()
        addPhotoCollectionView()
        
        photoCollectionView.dataSource = diffableDataSource
        photoCollectionView.setCollectionViewLayout(
            UICollectionViewCompositionalLayout.landscapeLayout,
            animated: false
        )
    }
    
    private func configurePaginationFetchControl() {
        paginationFetchControl.configure(scrollView: photoCollectionView)
        paginationFetchControl.didTriggerFetchMore = { [weak self] in
            self?.viewModel?.fetchNextPage()
        }
    }
    
    private func makeDiffableDataSource() -> DataSource {
        let photoContentCellRegistration = makePhotoContentCellRegistration()
        
        let diffableDataSource = DataSource(collectionView: photoCollectionView) {
            collectionView, indexPath, itemIdentifier in
            
            collectionView.dequeueConfiguredReusableCell(
                using: photoContentCellRegistration,
                for: indexPath,
                item: itemIdentifier
            )
        }
        
        return diffableDataSource
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
    
    private func addPhotoCollectionView() {
        view.addSubview(photoCollectionView)
        
        photoCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            photoCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            photoCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            photoCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            photoCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: Action(s)
    
    @objc private func didTapFilterButton() {
        guard let viewModel else { return }
        delegate?.didTapFilterButton(viewModel.currentFilterOptions())
    }
}
