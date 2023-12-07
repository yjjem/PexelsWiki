//
//  SearchViewController.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.


import UIKit

protocol SearchNavigatorViewControllerDelegate {
    func didSelectSearchQuery(_ searchQuery: String, contentType: ContentType)
}

final class SearchNavigatorViewController: UIViewController {
    
    // MARK: Type(s)
    
    typealias CategoryCellRegistration = UICollectionView.CellRegistration<CategoryCell, RecommendedCategory>
    typealias DataSource = UICollectionViewDiffableDataSource<Section, RecommendedCategory>
    typealias SnapShot = NSDiffableDataSourceSectionSnapshot<RecommendedCategory>
    
    enum Section {
        case category
    }
    
    // MARK: Variable(s)
    
    var viewModel: SearchNavigatorViewModel?
    var delegate: SearchNavigatorViewControllerDelegate?
    
    private var diffableDataSource: DataSource?
    private var snapShot: SnapShot = SnapShot()
    
    private let searchController: UISearchController = {
        let search = UISearchController()
        return search
    }()
    
    private let categoryCollectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: .init())
        return collection
    }()
    
    // MARK: Override(s)
    
    override func loadView() {
        super.loadView()
        
        configureView()
        configureNavigationItem()
        configureSearchController()
        configureCategoryCollectionView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUsingViewModel()
    }
    
    // MARK: Private Function(s)
    
    private func configureUsingViewModel() {
        guard let viewModel else { return }
        updateSnapShot(with: viewModel.categoryItems)
    }
    
    private func configureView() {
        view.backgroundColor = .systemGray6
    }
    
    private func configureNavigationItem() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func configureSearchController() {
        let searchBarPlaceHolderText = "Search Pexels Content"
        let searchBar = searchController.searchBar
        searchBar.scopeButtonTitles = ContentType.allCases.map { $0.name }
        searchBar.placeholder = searchBarPlaceHolderText
        searchBar.showsScopeBar = true
        searchBar.delegate = self
    }
    
    private func configureCategoryCollectionView() {
        let twoColumnGridLayout = makeTwoColumnGridLayout()
        diffableDataSource = makeDataSource()
        addCategoryCollectionView()
        
        categoryCollectionView.dataSource = diffableDataSource
        categoryCollectionView.delegate = self
        categoryCollectionView.setCollectionViewLayout(twoColumnGridLayout, animated: false)
    }
    
    private func addCategoryCollectionView() {
        view.addSubview(categoryCollectionView)
        
        categoryCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            categoryCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            categoryCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            categoryCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            categoryCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func makeDataSource() -> DataSource {
        let categoryCellRegistration = makeCategoryCellRegistration()
        
        let diffableDataSource = DataSource(collectionView: categoryCollectionView) {
            collectionView, indexPath, categoryItem in
            
            collectionView.dequeueConfiguredReusableCell(
                using: categoryCellRegistration,
                for: indexPath,
                item: categoryItem
            )
        }
        
        return diffableDataSource
    }
    
    private func makeCategoryCellRegistration() -> CategoryCellRegistration {
        return CategoryCellRegistration { cell, indexPath, categoryItem in
            cell.configure(using: categoryItem)
        }
    }
    
    private func makeTwoColumnGridLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1/3),
            heightDimension: .fractionalWidth(1/3)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            repeatingSubitem: item,
            count: 1
        )
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        section.contentInsets = .init(top: 0, leading: 15, bottom: 0, trailing: 15)
        section.orthogonalScrollingBehavior = .continuous
        
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
        guard let viewModel else { return }
        
        let selectedCategoryName = viewModel.categoryItems[indexPath.item].capitalizedName
        let selectedContentType = viewModel.searchContentType
        
        delegate?.didSelectSearchQuery(selectedCategoryName, contentType: selectedContentType)
    }
}

// MARK: UISearchBarDelegate

extension SearchNavigatorViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel?.searchQuery = searchText
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        guard let viewModel else { return }
        
        let selectedSearchContentType = ContentType.allCases[selectedScope]
        viewModel.searchContentType = selectedSearchContentType
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let viewModel else { return }
        
        let searchQuery = viewModel.searchQuery
        let contentType = viewModel.searchContentType
        
        delegate?.didSelectSearchQuery(searchQuery, contentType: contentType)
    }
}
