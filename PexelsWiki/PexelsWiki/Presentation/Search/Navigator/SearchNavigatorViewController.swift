//
//  SearchViewController.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.


import UIKit

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
    
    private let searchController: UISearchController = {
        let search = UISearchController()
        return search
    }()
    
    private let categoryCollectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: .init())
        return collection
    }()
    
    private var diffableDataSource: DataSource?
    private var snapShot: SnapShot = SnapShot()
    
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
        
        bindViewModel()
    }
    
    // MARK: Private Function(s)
    
    private func bindViewModel() {
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
        
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    private func updateSnapShot(with categoryList: [RecommendedCategory]) {
        snapShot.append(categoryList)
        diffableDataSource?.apply(snapShot, to: .category)
    }
    
    private func pushVideoSearchViewController(with query: String) {
        let provider = DefaultNetworkProvider()
        let repository = PexelsVideoRepository(provider: provider)
        let useCase = PexelsVideoSearchUseCase(repository: repository)
        let videoSearchViewModel = VideoSearchViewModel(useCase: useCase)
        
        let videoSearchViewController = VideoSearchViewController()
        videoSearchViewController.viewModel = videoSearchViewModel
        videoSearchViewModel.query = query
        
        navigationController?.pushViewController(videoSearchViewController, animated: true)
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

// MARK: UICollectionViewDelegate

extension SearchNavigatorViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let viewModel else { return }
        
        let selectedCategory = viewModel.categoryItems[indexPath.item]
        
        switch viewModel.searchContentType {
        case .image: pushPhotoSearchViewController(with: selectedCategory.capitalizedName)
        case .video: pushVideoSearchViewController(with: selectedCategory.capitalizedName)
        }
    }
}

// MARK: UISearchBarDelegate

extension SearchNavigatorViewController: UISearchBarDelegate {
    
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
        
        if selectedIndex == 1 {
            pushVideoSearchViewController(with: searchQuery)
        }
    }
}
