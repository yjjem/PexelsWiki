//
//  ImageSearchViewController.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.


import UIKit

final class PhotoSearchViewController: UIViewController {
    
    typealias PhotoContentCellRegistartion = UICollectionView.CellRegistration<PhotoContentCell, PhotoContentCellViewModel>
    typealias DataSource = UICollectionViewDiffableDataSource<Section, PhotoContentCellViewModel>
    typealias SnapShot = NSDiffableDataSourceSectionSnapshot<PhotoContentCellViewModel>
    
    enum Section {
        case main
    }
    
    var viewModel: PhotoSearchViewModel?
    
    private var diffableDataSource: DataSource?
    private var snapShot: SnapShot = SnapShot()
    
    private let photoCollectionView: UICollectionView = {
        let collection = UICollectionView(
            frame: .zero,
            collectionViewLayout: .init()
        )
        return collection
    }()
    
    override func loadView() {
        super.loadView()
        configurePhotoCollectionView()
        bindViewModel()
        configureNavigationItem()
    }
    
    private func addNavigationTitle(_ title: String) {
        navigationItem.title = title
    }
    
    private func bindViewModel() {
        guard let viewModel else { return }
        
        addNavigationTitle(viewModel.query)
        viewModel.loadSearchResults()
        viewModel.loadedPhotoResources = { [weak self] photoResources in
            self?.updateSnapShot(using: photoResources)
        }
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
    
    @objc func didTapFilterButton() {
        guard let viewModel else { return }
        
        let filterViewModel = SearchFilterViewModel(
            selectedOrientation: viewModel.orientation,
            selectedSize: viewModel.size
        )
        
        let filterView = makeFilterView()
        filterView.delegate = self
        filterView.viewModel = filterViewModel
        
        let navigation = UINavigationController(rootViewController: filterView)
        navigation.navigationBar.prefersLargeTitles = true
        
        present(navigation, animated: true)
    }
    
    private func makeFilterView() -> SearchFilterViewController {
        let filterView = SearchFilterViewController()
        filterView.delegate = self
        return filterView
    }
    
    private func configurePhotoCollectionView() {
        diffableDataSource = makeDiffableDataSource()
        
        addPhotoCollectionView()
        photoCollectionView.dataSource = diffableDataSource
        photoCollectionView.delegate = self
        photoCollectionView.setCollectionViewLayout(.landscapeLayout, animated: false)
    }
    
    private func makePhotoContentCellRegistration() -> PhotoContentCellRegistartion {
        let registration = PhotoContentCellRegistartion { cell, indexPath, cellViewModel in
            
            cell.configure(using: cellViewModel)
        }
        return registration
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
}

extension PhotoSearchViewController: SearchFilterViewControllerDelegate {
    
    func didApplyFilterOptions(_ options: FilterOptions) {
        
        guard let viewModel else { return }
        
        resetSnapShot()
        viewModel.apply(filter: options)
        
        switch viewModel.orientation {
        case .landscape:
            photoCollectionView.setCollectionViewLayout(.landscapeLayout, animated: true)
        case .portrait:
            photoCollectionView.setCollectionViewLayout(.makePortraitLayout, animated: true)
        case .square:
            photoCollectionView.setCollectionViewLayout(.squareLayout, animated: true)
        }
        
        viewModel.resetPage()
        
        photoCollectionView.scrollToItem(at: .init(item: 0, section: 0), at: .top, animated: true)
    }
}

extension PhotoSearchViewController: UICollectionViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let paginationPoint = scrollView.contentSize.height - scrollView.bounds.height
        let offset = scrollView.contentOffset.y
        
        if paginationPoint < offset {
            viewModel?.loadNextPage()
        }
    }
}
