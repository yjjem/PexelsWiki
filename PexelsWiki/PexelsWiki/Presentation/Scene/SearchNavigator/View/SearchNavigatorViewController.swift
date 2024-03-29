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
    
    // MARK: Type(s)
    
    typealias CategoryCellRegistration = UICollectionView.CellRegistration<CategoryCell, RecommendedCategory>
    typealias DataSource = UICollectionViewDiffableDataSource<Section, RecommendedCategory>
    typealias SnapShot = NSDiffableDataSourceSectionSnapshot<RecommendedCategory>
    
    enum Section {
        case category
    }
    
    // MARK: Property(s)
    
    var viewModel: SearchNavigatorViewModel?
    weak var delegate: SearchNavigatorViewControllerDelegate?
    
    private var diffableDataSource: DataSource?
    private var snapShot: SnapShot = SnapShot()
    
    private let searchController: UISearchController = UISearchController()
    private let categoryCollectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: .init())
        return collection
    }()
    
    // MARK: Override(s)
    
    override func loadView() {
        self.view = categoryCollectionView
        self.view.backgroundColor = .systemGray6
        categoryCollectionView.collectionViewLayout = makeTwoColumnGridLayout()
        categoryCollectionView.dataSource = diffableDataSource
        categoryCollectionView.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDiffableDataSource()
        configureNavigationItem()
        configureSearchController()
        configureUsingViewModel()
    }
    
    // MARK: Private Function(s)
    
    private func configureUsingViewModel() {
        guard let viewModel else { return }
        updateSnapShot(with: viewModel.shuffledCategories())
    }
    
    private func configureNavigationItem() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.backButtonDisplayMode = .minimal
    }
    
    private func configureSearchController() {
        let searchBarPlaceHolderText = "Search Pexels Content"
        let searchBar = searchController.searchBar
        searchBar.placeholder = searchBarPlaceHolderText
        searchBar.delegate = self
    }
    
    private func configureDiffableDataSource() {
        let categoryCellRegistration = makeCategoryCellRegistration()
        let sectionHeaderRegistration = makeSectionHeaderRegistration()
        let diffableDataSource = DataSource(collectionView: categoryCollectionView) {
            collectionView, indexPath, categoryItem in
            
            collectionView.dequeueConfiguredReusableCell(
                using: categoryCellRegistration,
                for: indexPath,
                item: categoryItem
            )
        }
        
        diffableDataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            collectionView.dequeueConfiguredReusableSupplementary(
                using: sectionHeaderRegistration,
                for: indexPath
            )
        }
        self.diffableDataSource = diffableDataSource
    }
    
    private func makeSectionHeaderRegistration() -> UICollectionView.SupplementaryRegistration<SectionTitleHeader> {
        return .init(elementKind: UICollectionView.elementKindSectionHeader) { 
            supplementaryView, elementKind, indexPath in
            supplementaryView.addTitle("Recommended Categories")
        }
    }
    
    private func makeCategoryCellRegistration() -> CategoryCellRegistration {
        return CategoryCellRegistration { cell, indexPath, categoryItem in
            cell.configure(using: categoryItem)
        }
    }
    
    private func makeTwoColumnGridLayout() -> UICollectionViewCompositionalLayout {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1/3),
                heightDimension: .estimated(1)
            )
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: item.layoutSize.heightDimension
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
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    private func updateSnapShot(with categoryList: [RecommendedCategory]) {
        snapShot.append(categoryList)
        diffableDataSource?.apply(snapShot, to: .category)
    }
}

// MARK: UICollectionViewDelegate

extension SearchNavigatorViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelectSearchQuery(snapShot.items[indexPath.row].rawValue)
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
