//
//  CollectionMediaDataSource.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.
    

import UIKit

final class CollectionMediaDataSource {
    
    // MARK: Type(s)
    
    enum Section {
        case main
    }
    
    // MARK: Property(s)
    
    private var diffableDataSource: UICollectionViewDiffableDataSource<Section, MediaCollectionViewModel.MediaPreview>?
    
    init(collectionView: UICollectionView) {
        initializeDiffableDataSource(collectionView)
    }
    
    // MARK: Function(s)
    
    func addMediaItems(_ mediaItems: [MediaCollectionViewModel.MediaPreview]) {
        guard let diffableDataSource else {
            return
        }
        var mutatedSnapshot = diffableDataSource.snapshot(for: .main)
        mutatedSnapshot.append(mediaItems)
        diffableDataSource.apply(mutatedSnapshot, to: .main)
    }
    
    private func initializeDiffableDataSource(_ collectionView: UICollectionView) {
        let mediaCellRegistration = makePhotoMediaCellRegistration()
        self.diffableDataSource = UICollectionViewDiffableDataSource<Section, MediaCollectionViewModel.MediaPreview>(
            collectionView: collectionView
        ) { collectionView, indexPath, itemIdentifier in
            
            return collectionView.dequeueConfiguredReusableCell(
                using: mediaCellRegistration,
                for: indexPath,
                item: itemIdentifier
            )
        }
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
}
