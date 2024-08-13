//
//  FeaturedCollectionListViewController.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.


import UIKit

final class DiscoverCollectionListViewController: UIViewController {
    
    // MARK: Type(s)
    
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, FeaturedCollectionCellViewModel>
    private enum Section { case featuredCollections }
    
    // MARK: Property(s)
    
    var viewModel: FeaturedCollectionsListViewModel?
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, FeaturedCollectionCellViewModel>?
    private var keywordsSectionSnapShot = NSDiffableDataSourceSectionSnapshot<FeaturedCollectionCellViewModel>()
    
    private let collectionView: UICollectionView = UICollectionView(
        frame: .zero, 
        collectionViewLayout: .init()
    )
    
    // MARK: Override(s)
    
    override func loadView() {
        self.view = collectionView
        configureCollectionView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDataSource()
        bindViewModel()
        viewModel?.onViewDidLoad()
    }
    
    // MARK: Private Function(s)
    
    private func bindViewModel() {
        viewModel?.receivedCollectionKeywords = { [weak self] collectionKeywords in
            self?.updateKeywords(collectionKeywords)
        }
    }
    
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
    
    private func updateKeywords(_ newKeywords: [FeaturedCollectionCellViewModel]) {
        keywordsSectionSnapShot.append(newKeywords)
        dataSource?.apply(keywordsSectionSnapShot, to: .featuredCollections)
    }
}
