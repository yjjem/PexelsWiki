//
//  SearchNavigatorDataSource.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.


import UIKit

final class SearchNavigatorDataSource {
    
    // MARK: Type(s)
    
    enum Section: CaseIterable {
        case recommendedCategories
        case featuredCollections
        
        enum Item: Hashable {
            case recommendedCategory(RecommendedCategoryCellViewModel)
            case featuredCollection(FeaturedCollectionCellViewModel)
        }
        
        var title: String {
            switch self {
            case .recommendedCategories: return "Recommended Categories"
            case .featuredCollections: return "Featured Collections"
            }
        }
    }
    
    // MARK: Property(s)
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, Section.Item>?
    
    // MARK: Private Function(s)
    
    private func makeCategoryCellRegistration(
    ) -> UICollectionView.CellRegistration<RecommendedCategoryCell, Section.Item> {
        
        return UICollectionView.CellRegistration<RecommendedCategoryCell, Section.Item> {
            cell, indexPath, categoryItem in
            if case .recommendedCategory(let category) = categoryItem {
                cell.configure(using: category)
            }
        }
    }
    
    private func makeFeaturedCollectionCellRegistration(
    ) -> UICollectionView.CellRegistration<FeaturedCollectionCell, Section.Item> {
        return UICollectionView.CellRegistration<FeaturedCollectionCell, Section.Item> {
            cell, indexPath, collectionItem in
            
            if case .featuredCollection(let collection) = collectionItem {
                cell.configure(using: collection)
            }
        }
    }
    
    private func makeSectionHeaderRegistration(
    ) -> UICollectionView.SupplementaryRegistration<SectionTitleHeader> {
        
        return UICollectionView.SupplementaryRegistration<SectionTitleHeader>(
            elementKind: UICollectionView.elementKindSectionHeader
        ) {
            supplementaryView, elementKind, indexPath in
            let sectionTitle = Section.allCases[indexPath.section].title
            supplementaryView.addTitle(sectionTitle)
        }
    }
    
    private func applyInitialSnapshot() {
        var initialSnapshot = NSDiffableDataSourceSnapshot<Section, Section.Item>()
        initialSnapshot.appendSections(Section.allCases)
        dataSource?.apply(initialSnapshot)
    }
    
    // MARK: Function(s)
    
    func initializeDataSource(_ targetCollectionView: UICollectionView) {
        configureDataSourceCellProvider(using: targetCollectionView)
        guard let dataSource else {
            return
        }
        configureDataSourceSupplementaryViewProvider(using: dataSource)
        applyInitialSnapshot()
    }
    
    private func configureDataSourceCellProvider(using collectionView: UICollectionView ) {
        let categoryCellRegistration = makeCategoryCellRegistration()
        let featuredCollectionCellRegistration = makeFeaturedCollectionCellRegistration()
        
        let dataSource = UICollectionViewDiffableDataSource<Section, Section.Item>(
            collectionView: collectionView
        ) { collectionView, indexPath, sectionItem in
            
            switch Section.allCases[indexPath.section] {
            case .recommendedCategories:
                return collectionView.dequeueConfiguredReusableCell(
                    using: categoryCellRegistration,
                    for: indexPath,
                    item: sectionItem
                )
            case .featuredCollections:
                return collectionView.dequeueConfiguredReusableCell(
                    using: featuredCollectionCellRegistration,
                    for: indexPath,
                    item: sectionItem
                )
            }
        }
        self.dataSource = dataSource
    }
    
    private func configureDataSourceSupplementaryViewProvider(
        using dataSource: UICollectionViewDiffableDataSource<Section, Section.Item>
    ) {
        let sectionHeader = makeSectionHeaderRegistration()
        dataSource.supplementaryViewProvider = { collectionView, kine, indexPath in
            return collectionView.dequeueConfiguredReusableSupplementary(
                using: sectionHeader,
                for: indexPath
            )
        }
    }
    
    func updateRecommendedCategoriesSection(with categories: [RecommendedCategoryCellViewModel]) {
        guard var recommendedCategoriesSnapshot = dataSource?.snapshot(for: .recommendedCategories)
        else {
            return
        }
        
        let recommendedCategoriesSectionItems = categories
            .map { Section.Item.recommendedCategory($0) }
        recommendedCategoriesSnapshot.append(recommendedCategoriesSectionItems)
        dataSource?.apply(recommendedCategoriesSnapshot, to: .recommendedCategories)
    }
    
    func updateFeaturedCollectionKeywordSection(
        with keywords: [FeaturedCollectionCellViewModel]
    ) {
        guard var featuredCollectionsSnapshot = dataSource?.snapshot(for: .featuredCollections)
        else {
            return
        }
        
        let featuredCollectionsSectionItem = keywords
            .map { Section.Item.featuredCollection($0) }
        featuredCollectionsSnapshot.append(featuredCollectionsSectionItem)
        dataSource?.apply(featuredCollectionsSnapshot, to: .featuredCollections)
    }

    func sectionItem(for indexPath: IndexPath) -> Section.Item? {
        return dataSource?.itemIdentifier(for: indexPath)
    }
}
