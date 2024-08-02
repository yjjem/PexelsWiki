//
//  FeaturedCollectionListViewController.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.


import UIKit

final class DiscoverCollectionListViewController: UIViewController {
    
    // MARK: Type(s)
    
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, CollectionKeyword>
    private enum Section { case featuredCollections }
    
    // MARK: Property(s)
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, CollectionKeyword>?
    private var keywordsSectionSnapShot = NSDiffableDataSourceSectionSnapshot<CollectionKeyword>()
    
    private let collectionView: UICollectionView = UICollectionView(
        frame: .zero, 
        collectionViewLayout: .init()
    )
    
    // MARK: Override(s)
    
    override func loadView() {
        self.view = collectionView
        configureCollectionView()
        configureDataSource()
    }
    
    // MARK: Private Function(s)
    
    private func configureCollectionView() {
        collectionView.dataSource = dataSource
    }
    
    private func configureDataSource() {
        self.dataSource = DataSource(collectionView: collectionView) {
            collectionView, indexPath, collectionKeyword in
            
            // MARK: TODO -> add custom cell
            
            return UICollectionViewCell()
        }
    }
    
    private func updateKeywords(_ newKeywords: [CollectionKeyword]) {
        keywordsSectionSnapShot.append(newKeywords)
        dataSource?.apply(keywordsSectionSnapShot, to: .featuredCollections)
    }
}
