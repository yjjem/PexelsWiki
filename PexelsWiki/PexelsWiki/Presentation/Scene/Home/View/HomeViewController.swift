//
//  ViewController.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.


import UIKit

protocol HomeViewControllerDelegate: AnyObject {
    func didSelectItem(id: Int)
}

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
    weak var delegate: HomeViewControllerDelegate?
    
    private var diffableDataSource: DataSource?
    private var snapShot: SnapShot = SnapShot()
    
    private let contentRefreshControl: UIRefreshControl = UIRefreshControl()
    private let contentCollectionView: UICollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: .init()
    )
    
    // MARK: Override(s)
    
    override func loadView() {
        self.view = contentCollectionView
        contentCollectionView.setCollectionViewLayout(createCompositionalLayout(), animated: true)
        contentCollectionView.refreshControl = contentRefreshControl
        contentCollectionView.dataSource = diffableDataSource
        contentCollectionView.backgroundColor = .systemGray6
        contentCollectionView.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        configureContentRefreshControl()
        configureDiffableDataSource()
        viewModel?.fetchCuratedPhotosPage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    // MARK: Private Function(s)
    
    private func bindViewModel() {
        viewModel?.loadedHomeContentViewModelList = { [weak self] viewModelList in
            guard let self else { return }
            if let viewModelList {
                let snapShotItems = self.snapShot.items
                let itemsWithoutDuplication = viewModelList.filter { !snapShotItems.contains($0) }
                applySnapShot(with: itemsWithoutDuplication)
            }
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

// MARK: UICollectionViewDelegate

extension HomeViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let selectedItem = diffableDataSource?.itemIdentifier(for: indexPath) {
            delegate?.didSelectItem(id: selectedItem.imageID)
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        if needFetchMore(
            willDisplay: indexPath,
            itemsCount: snapShot.items.count,
            edgeCountInset: 3
        ) {
            viewModel?.fetchNextPage()
        }
    }
}
