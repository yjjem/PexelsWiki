//
//  ViewController.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.


import UIKit

final class HomeViewController: UIViewController {
    
    // MARK: Type(s)
    
    typealias ContentCellRegistration = UICollectionView.CellRegistration<HomeContentCell, HomeContentCellViewModel>
    typealias DataSource = UICollectionViewDiffableDataSource<Section, HomeContentCellViewModel>
    typealias SnapShot = NSDiffableDataSourceSectionSnapshot<HomeContentCellViewModel>
    
    enum Section {
        case main
    }
    
    // MARK: Property(s)
    
    var viewModel: HomeViewModel?
    
    private var diffableDataSource: DataSource?
    private var snapShot: SnapShot = SnapShot()
    
    private let paginationFetchControl: PaginationFetchControl = PaginationFetchControl()
    private let contentRefreshControl: UIRefreshControl = UIRefreshControl()
    private let contentCollectionView: UICollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: .init()
    )
    
    // MARK: Override(s)
    
    override func loadView() {
        self.view = contentCollectionView
        contentCollectionView.backgroundColor = .systemGray6
        contentCollectionView.refreshControl = contentRefreshControl
        contentCollectionView.dataSource = diffableDataSource
        contentCollectionView.setCollectionViewLayout(createCompositionalLayout(), animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        configureContentRefreshControl()
        configureDiffableDataSource()
        configurePaginationFetchControl()
        viewModel?.fetchCuratedPhotosPage()
    }
    
    // MARK: Private Function(s)
    
    private func bindViewModel() {
        viewModel?.loadedHomeContentViewModelList = { [weak self] viewModelList in
            guard let self else { return }
            let snapShotItems = self.snapShot.items
            let itemsWithoutDuplication = viewModelList.filter { !snapShotItems.contains($0) }
            applySnapShot(with: itemsWithoutDuplication)
            endRefreshing()
        }
    }
    
    private func configureContentRefreshControl() {
        let refreshAction = #selector(didInvokeRefresh)
        contentRefreshControl.addTarget(self, action: refreshAction, for: .valueChanged)
    }
    
    private func endRefreshing() {
        DispatchQueue.main.async {
            if self.contentRefreshControl.isRefreshing {
                self.contentRefreshControl.endRefreshing()
            }
        }
    }
    
    private func configurePaginationFetchControl() {
        paginationFetchControl.configure(scrollView: contentCollectionView)
        paginationFetchControl.didTriggerFetchMore = { [weak self] in
            self?.viewModel?.fetchNextPage()
        }
    }
    
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(1.0)
        )
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(100)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            repeatingSubitem: item,
            count: 1
        )
        
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    private func configureDiffableDataSource() {
        let contentCellRegistration = makeContentCellRegistration()
        let diffableDataSource = DataSource(collectionView: contentCollectionView) {
            collectionView, indexPath, viewModel in
            
            collectionView.dequeueConfiguredReusableCell(
                using: contentCellRegistration,
                for: indexPath,
                item: viewModel
            )
        }
        self.diffableDataSource = diffableDataSource
    }
    
    private func makeContentCellRegistration() -> ContentCellRegistration {
        return ContentCellRegistration { cell, indexPath, viewModel in
            cell.configure(using: viewModel)
        }
    }
    
    private func applySnapShot(with resources: [HomeContentCellViewModel]) {
        snapShot.append(resources)
        diffableDataSource?.apply(snapShot, to: .main)
    }
    
    // MARK: Action(s)
    
    @objc private func didInvokeRefresh() {
        snapShot.deleteAll()
        viewModel?.resetPage()
    }
}
