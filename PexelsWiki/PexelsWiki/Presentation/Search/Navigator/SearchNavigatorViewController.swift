//
//  SearchViewController.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.


import UIKit

final class SearchNavigatorViewController: UIViewController {
    
    typealias CategoryCellRegistration = UICollectionView.CellRegistration<CategoryCell, Category>
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Category>
    typealias SnapShot = NSDiffableDataSourceSectionSnapshot<Category>
    
    enum Section {
        case category
    }
    
    private var diffableDataSource: DataSource?
    private var snapShot: SnapShot = SnapShot()
    
    var viewModel: SearchNavigatorViewModel?
    
    private let searchController: UISearchController = {
        let search = UISearchController()
        return search
    }()
    
    private let categoryCollectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: .init())
        return collection
    }()
    
    override func loadView() {
        super.loadView()
        
        configureView()
        configureNavigationItem()
        configureSearchController()
        configureCategoryCollectionView()
        bindViewModel()
    }
    
    private func bindViewModel() {
        guard let viewModel else { return }
        updateSnapShot(with: viewModel.categoryItems)
    }
    
    private func configureView() {
        view.backgroundColor = .systemGray6
    }
    
    private func configureSearchController() {
        let searchBar = searchController.searchBar
        searchBar.placeholder = "Search Pexels Content"
        searchBar.scopeButtonTitles = ContentType.allCases.map { $0.name }
    }
    
    private func configureNavigationItem() {
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
    }
    
    private func configureCategoryCollectionView() {
        let twoColumnGridLayout = makeTwoColumnGridLayout()
        diffableDataSource = makeDataSource()
        addCategoryCollectionView()
        categoryCollectionView.dataSource = diffableDataSource
        categoryCollectionView.setCollectionViewLayout(twoColumnGridLayout, animated: false)
    }
    
    private func updateSnapShot(with categoryList: [Category]) {
        snapShot.append(categoryList)
        diffableDataSource?.apply(snapShot, to: .category)
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
    
    private func makeCategoryCellRegistration() -> CategoryCellRegistration {
        let categoryRegistration = CategoryCellRegistration { cell, indexPath, categoryItem in
            
            cell.configure(using: categoryItem)
        }
        
        return categoryRegistration
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
    
    private func makeTwoColumnGridLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1/2),
            heightDimension: .fractionalHeight(1/1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1/1),
            heightDimension: .fractionalWidth(1/2)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            repeatingSubitem: item,
            count: 2
        )
        group.interItemSpacing = .fixed(5)
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    private func pushPhotoSearchViewController(with query: String) {
        
        let provider = DefaultNetworkProvider()
        let repository = PexelsPhotoRepository(provider: provider)
        let useCase = PexelsPhotoSearchUseCase(repository: repository)
        let photoSearchViewModel = PhotoSearchViewModel(useCase: useCase)
        
        let photoSearchViewController = PhotoSearchViewController()
        photoSearchViewController.viewModel = photoSearchViewModel
        photoSearchViewModel.query = query
        
        navigationController?.pushViewController(photoSearchViewController, animated: true)
    }
}

extension SearchNavigatorViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsScopeBar = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsScopeBar = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel?.searchQuery = searchText
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        if selectedScope == 1 {
            viewModel?.searchContentType = .video
        } else {
            viewModel?.searchContentType = .image
        }
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let viewModel else { return }
        
        let searchQuery = viewModel.searchQuery
        let selectedIndex = searchBar.selectedScopeButtonIndex
        
        if selectedIndex == 0 {
            pushPhotoSearchViewController(with: searchQuery)
        }
    }
}
