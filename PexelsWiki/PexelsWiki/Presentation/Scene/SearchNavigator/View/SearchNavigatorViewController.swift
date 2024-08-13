//
//  SearchViewController.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.


import UIKit

protocol SearchNavigatorViewControllerDelegate: AnyObject {
    func didSelectSearchQuery(_ searchQuery: String)
}

final class SearchNavigatorViewController: UIViewController {
    
    // MARK: Property(s)
    
    var viewModel: SearchNavigatorViewModel?
    weak var delegate: SearchNavigatorViewControllerDelegate?
    
    private let datasource: SearchNavigatorDataSource = SearchNavigatorDataSource()
    private let searchController: UISearchController = UISearchController()
    private let categoryCollectionView: UICollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: .init()
    )
    
    // MARK: Override(s)
    
    override func loadView() {
        self.view = categoryCollectionView
        self.view.backgroundColor = .secondarySystemBackground
        categoryCollectionView.collectionViewLayout = makeUICollectionViewCompositionalLayout()
        categoryCollectionView.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datasource.initializeDataSource(categoryCollectionView)
        configureNavigationItem()
        configureSearchController()
        configureUsingViewModel()
        viewModel?.onViewDidLoad()
    }
    
    // MARK: Private Function(s)
    
    private func configureUsingViewModel() {
        guard let viewModel else { return }
        datasource.updateRecommendedCategoriesSection(with: viewModel.shuffledCategories())
        viewModel.loadedFeaturedCollectionKeywords = { viewModels in
            self.datasource.updateFeaturedCollectionKeywordSection(with: viewModels)
        }
    }
    
    private func configureNavigationItem() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.backButtonDisplayMode = .minimal
    }
    
    private func configureSearchController() {
        let searchBar = searchController.searchBar
        searchBar.placeholder = Constants.searchBarPlaceholder
        searchBar.delegate = self
    }
    
    private func makeRecommendedCategoriesSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1/3),
                heightDimension: .fractionalHeight(1)
            )
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1/5)
            ),
            repeatingSubitem: item,
            count: 3
        )
        group.interItemSpacing = .fixed(10)
        
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(44)
            ),
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        section.contentInsets = .init(top: 0, leading: 15, bottom: 0, trailing: 15)
        section.orthogonalScrollingBehavior = .continuous
        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
    }
    
    private func makeFeaturedCollectionsSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1/2),
                heightDimension: .absolute(110)
            ),
            subitems: [item]
        )
        
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(44)
            ),
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        section.contentInsets = .init(top: 0, leading: 15, bottom: 0, trailing: 15)
        section.orthogonalScrollingBehavior = .continuous
        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
    }
    
    private func makeUICollectionViewCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let recommendedCategoriesSection = makeRecommendedCategoriesSection()
        let featuredCollectionsSection = makeFeaturedCollectionsSection()
        
        return UICollectionViewCompositionalLayout { sectionIndex, environment in
            
            let sectionType = SearchNavigatorDataSource.Section.allCases[sectionIndex]
            
            switch sectionType {
            case .recommendedCategories: 
                return recommendedCategoriesSection
            case .featuredCollections: 
                return featuredCollectionsSection
            }
        }
    }
}

// MARK: UICollectionViewDelegate

extension SearchNavigatorViewController: UICollectionViewDelegate {
    
    private func selectQuery(_ selectedIndexPath: IndexPath) {
        let sectionItem = datasource.sectionItem(for: selectedIndexPath)
        if case .recommendedCategory(let category) = sectionItem {
            delegate?.didSelectSearchQuery(category.imageName)
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        selectQuery(indexPath)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
    }
}

// MARK: UISearchBarDelegate

extension SearchNavigatorViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel?.updateQuery(searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let query = viewModel?.currentQuery() {
            delegate?.didSelectSearchQuery(query)
        }
    }
}

// MARK: Static Constants

fileprivate enum Constants {
    static let searchBarPlaceholder = "Search Pexels Content"
}
