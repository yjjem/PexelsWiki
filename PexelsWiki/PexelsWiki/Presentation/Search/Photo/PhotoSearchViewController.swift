//
//  ImageSearchViewController.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.


import UIKit

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
    
    private let photoCollectionView: UICollectionView = {
        let collection = UICollectionView(
            frame: .zero,
            collectionViewLayout: .init()
        )
        return collection
    }()
    
    private var diffableDataSource: DataSource?
    private var snapShot: SnapShot = SnapShot()
    
    // MARK: Override(s)
    
    override func loadView() {
        super.loadView()
        
        configureNavigationItem()
        configurePhotoCollectionView()
        
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
        
        viewModel?.loadSearchResults()
    }
    
    // MARK: Private Function(s)
    
    private func bindViewModel() {
        guard let viewModel else { return }
        
        viewModel.loadedPhotoContentCellViewModels = { [weak self] photoResources in
            
            guard let self else { return }
            let snapShotItems = self.snapShot.items
            let itemsWithoutDuplications = snapShotItems.filter { !snapShotItems.contains($0) }
            self.updateSnapShot(using: itemsWithoutDuplications)
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
    
    private func makeFilterView(
        with viewModel: SearchFilterViewModel
    ) -> SearchFilterViewController {
        
        let filterView = SearchFilterViewController()
        filterView.viewModel = viewModel
        filterView.delegate = self
        
        return filterView
    }
    
    private func configurePhotoCollectionView() {
        diffableDataSource = makeDiffableDataSource()
        addPhotoCollectionView()
        
        photoCollectionView.dataSource = diffableDataSource
        photoCollectionView.delegate = self
        photoCollectionView.setCollectionViewLayout(
            UICollectionViewCompositionalLayout.landscapeLayout,
            animated: false
        )
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
    
    @objc func didTapFilterButton() {
        guard let viewModel else { return }
        
        let filterViewModel = SearchFilterViewModel(
            selectedOrientation: viewModel.orientation,
            selectedSize: viewModel.size
        )
        let filterView = makeFilterView(with: filterViewModel)
        
        let navigation = UINavigationController(rootViewController: filterView)
        navigation.navigationBar.prefersLargeTitles = true
        
        present(navigation, animated: true)
    }
}

// MARK: SearchFilterViewControllerDelegate

extension PhotoSearchViewController: SearchFilterViewControllerDelegate {
    
    func didApplyFilterOptions(_ options: FilterOptions) {
        guard let viewModel else { return }
        
        resetSnapShot()
        viewModel.apply(filter: options)
        
        switch viewModel.orientation {
        case .landscape:
            photoCollectionView.setCollectionViewLayout(
                UICollectionViewCompositionalLayout.landscapeLayout,
                animated: true
            )
        case .portrait:
            photoCollectionView.setCollectionViewLayout(
                UICollectionViewCompositionalLayout.portraitLayout,
                animated: true
            )
        case .square:
            photoCollectionView.setCollectionViewLayout(
                UICollectionViewCompositionalLayout.squareLayout,
                animated: true
            )
        }
        
        viewModel.resetPage()
        
        let topIndexPath = IndexPath(item: 0, section: 0)
        photoCollectionView.scrollToItem(at: topIndexPath, at: .top, animated: true)
    }
}

// MARK: UICollectionViewDelegate

extension PhotoSearchViewController: UICollectionViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let paginationPoint = scrollView.contentSize.height - scrollView.bounds.height
        let offset = scrollView.contentOffset.y
        
        if paginationPoint < offset {
            viewModel?.loadNextPage()
        }
    }
}
