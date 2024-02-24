//
//  ImageSearchViewController.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.


import UIKit

protocol PhotoSearchViewControllerDelegate: AnyObject {
    func didTapFilterButton(_ currentOptions: FilterOptions)
}

final class PhotoListViewController: UIViewController {
    
    // MARK: Type(s)
    
    typealias PhotoContentCellRegistartion = UICollectionView.CellRegistration<PhotoContentCell, PhotoContentCellViewModel>
    typealias DataSource = UICollectionViewDiffableDataSource<Section, PhotoContentCellViewModel>
    typealias SnapShot = NSDiffableDataSourceSectionSnapshot<PhotoContentCellViewModel>
    
    enum Section {
        case main
    }
    
    // MARK: Property(s)
    
    var viewModel: PhotoListViewModel?
    weak var delegate: PhotoSearchViewControllerDelegate?
    
    private var diffableDataSource: DataSource?
    private var snapShot: SnapShot = SnapShot()
    
    private let photoCollectionView: UICollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: .init()
    )
    
    // MARK: Override(s)
    
    override func loadView() {
        self.view = photoCollectionView
        photoCollectionView.setCollectionViewLayout(createLayout(), animated: true)
        photoCollectionView.dataSource = diffableDataSource
        photoCollectionView.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        configureDiffableDataSource()
        configureNavigationItem()
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
        navigationItem.title = viewModel?.currentQuery()
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
    
    // MARK: Compositional Layout
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        let doubleItemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .fractionalWidth(1/2 * 0.68)
        )
        let doubleItem = NSCollectionLayoutItem(layoutSize: doubleItemSize)
        
        let doubleGroupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(1.0)
        )
        let doubleGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: doubleGroupSize,
            repeatingSubitem: doubleItem,
            count: 2
        )
        doubleGroup.interItemSpacing = .fixed(2.5)
        
        let fullItemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(0.68)
        )
        let fullItem = NSCollectionLayoutItem(layoutSize: fullItemSize)
        
        let mixedGroupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(1)
        )
        let mixedGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: mixedGroupSize,
            subitems: [doubleGroup, fullItem, doubleGroup]
        )
        
        let mainGroupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(1)
        )
        let mainGroup = NSCollectionLayoutGroup.vertical(layoutSize: mainGroupSize, subitems: [doubleGroup, doubleGroup, fullItem, mixedGroup, doubleGroup])
        
        let section = NSCollectionLayoutSection(group: mainGroup)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
}

// MARK: UICollectionViewDelegate

extension PhotoListViewController: UICollectionViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.isOverPaginationPoint() {
            viewModel?.fetchNextPage()
        }
    }
}

