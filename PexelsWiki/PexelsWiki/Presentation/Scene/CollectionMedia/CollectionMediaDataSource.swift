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
    
    var totalNumberOfItems: Int? {
        return diffableDataSource?.snapshot().numberOfItems
    }
    
    private var diffableDataSource: UICollectionViewDiffableDataSource<Section, MediaCollectionViewModel.MediaPreview>?
    private let imageUtility: ImageUtilityManager = ImageUtilityManager()
    
    init(collectionView: UICollectionView) {
        initializeDiffableDataSource(collectionView)
    }
    
    // MARK: Function(s)
    
    func item(at indexPath: IndexPath) -> MediaCollectionViewModel.MediaPreview? {
        return diffableDataSource?.itemIdentifier(for: indexPath)
    }
    
    func addMediaItems(_ mediaItems: [MediaCollectionViewModel.MediaPreview]) {
        guard let diffableDataSource else {
            return
        }
        var mutatedSnapshot = diffableDataSource.snapshot(for: .main)
        mutatedSnapshot.append(mediaItems)
        diffableDataSource.apply(mutatedSnapshot, to: .main)
    }
    
    // MARK: Private Function(s)
    
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
    ) -> UICollectionView.CellRegistration<CollectionMediaPreviewCell, MediaCollectionViewModel.MediaPreview> {
        return UICollectionView.CellRegistration<CollectionMediaPreviewCell, MediaCollectionViewModel.MediaPreview>() {
            cell, indexPath, itemIdentifier in
            
            let size = cell.frame.size
            
            if itemIdentifier.type == .video {
                cell.markAsVideo()
            }
            
            DispatchQueue.global(qos: .userInteractive).async { [size] in
                self.imageUtility.thumbnail(for: itemIdentifier.image, toFit: size, cropStrategy: .centerSquare) { image in
                DispatchQueue.main.async {
                        let animationOptions: UIView.AnimationOptions = [.transitionCrossDissolve, .allowUserInteraction]
                        UIView.transition(with: cell, duration: 0.3, options: animationOptions) {
                            cell.imageView.image = image
                        }
                    }
                }
            }
        }
    }
}
