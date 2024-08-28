//
//  CollectionMediaListViewController.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.


import UIKit

final class CollectionMediaListViewController: UIViewController {
    
    // MARK: Type(s)
    
    enum Section {
        case main
    }
    
    // MARK: Property(s)
    
    var viewModel: MediaCollectionViewModel?
    
    private let collectionView: UICollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: .init()
    )
    private var dataSource: UICollectionViewDiffableDataSource<Section, MediaCollectionViewModel.MediaPreview>?
    
    // MARK: Function(s)
    
    override func loadView() {
        self.view = collectionView
        configureDataSource()
        collectionView.dataSource = dataSource
        collectionView.collectionViewLayout = createCompositionalLayout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        viewModel?.onViewDidLoad()
    }
    
    // MARK: Private Function(s)
    
    private func bindViewModel() {
        viewModel?.loadedMediaPreviews = { [weak self] previewItems in
            self?.addMediaItems(previewItems)
        }
    }
    
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        return UICollectionViewCompositionalLayout.list(using: configuration)
    }
    
    private func makePhotoMediaCellRegistration(
    ) -> UICollectionView.CellRegistration<UICollectionViewListCell, MediaCollectionViewModel.MediaPreview> {
        
        let imageUtility: ImageUtilityManager = ImageUtilityManager()
        
        return UICollectionView.CellRegistration<UICollectionViewListCell, MediaCollectionViewModel.MediaPreview>() {
            cell, indexPath, itemIdentifier in
            
            var cellContent = cell.defaultContentConfiguration()
            cellContent.text = itemIdentifier.user
            cellContent.secondaryText = itemIdentifier.identifier
            cellContent.imageProperties.maximumSize = .init(width: 80, height: 80)
            
            guard cellContent.image == nil else {
                cell.contentConfiguration = cellContent
                return
            }
            
            imageUtility.requestImage(for: itemIdentifier.image) { image in
                cellContent.image = image
                DispatchQueue.main.async {
                    cell.contentConfiguration = cellContent
                }
            }
        }
    }
    
    private func configureDataSource() {
        let mediaCellRegistration = makePhotoMediaCellRegistration()
        self.dataSource = UICollectionViewDiffableDataSource<Section, MediaCollectionViewModel.MediaPreview>(
            collectionView: collectionView
        ) { collectionView, indexPath, itemIdentifier in
            
            return collectionView.dequeueConfiguredReusableCell(
                using: mediaCellRegistration,
                for: indexPath,
                item: itemIdentifier
            )
        }
    }
    
    private func addMediaItems(_ mediaItems: [MediaCollectionViewModel.MediaPreview]) {
        guard let dataSource else {
            return
        }
        var mutatedSnapshot = dataSource.snapshot(for: .main)
        mutatedSnapshot.append(mediaItems)
        dataSource.apply(mutatedSnapshot, to: .main)
    }
}
