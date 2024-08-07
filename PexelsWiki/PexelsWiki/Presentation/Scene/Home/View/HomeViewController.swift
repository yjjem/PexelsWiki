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
    
    private let imageUtilityManager = ImageUtilityManager()
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
        contentCollectionView.showsVerticalScrollIndicator = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        configureContentRefreshControl()
        configureDiffableDataSource()
        viewModel?.onNeedItems()
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
        return UICollectionViewCompositionalLayout { section, environment in
            let items = self.contentCollectionView.numberOfItems(inSection: .zero)
            let customGroup = NSCollectionLayoutGroup.custom(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .estimated(environment.container.effectiveContentSize.height)
                )
            ) { environment in
                
                let itemWidth = environment.container.effectiveContentSize.width
                let contentInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
                var groupItems: [NSCollectionLayoutGroupCustomItem] = .init()
                var previousItemOriginY: CGFloat = 0
                
                for index in 0..<items {
                    let viewModelForIndex = self.snapShot.items[index]
                    let (height, width) = (CGFloat(viewModelForIndex.imageHeight), CGFloat(viewModelForIndex.imageWidth))
                    let itemHeight = height * itemWidth / width
                    let newItemOrigin = CGPoint(x: .zero, y: previousItemOriginY)
                    let newItemSize = CGSize(width: itemWidth, height: itemHeight)
                    let newItemFrame = CGRect(origin: newItemOrigin,size: newItemSize)
                        .inset(by: contentInset)
                    
                    let newCustomItem = NSCollectionLayoutGroupCustomItem(frame: newItemFrame)
                    groupItems.append(newCustomItem)
                    
                    previousItemOriginY = newItemFrame.maxY
                }
                
                return groupItems
            }
            return NSCollectionLayoutSection(group: customGroup)
        }
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
        return ContentCellRegistration { [weak self] cell, indexPath, cellViewModel in
            let currentLayoutSize = self?.contentCollectionView
                .layoutAttributesForItem(at: indexPath)
            
            cell.imageView.image = nil
            cell.imageView.isOpaque = true
            cell.backgroundColor = .quaternarySystemFill
            cell.imageRequest = self?.imageUtilityManager.thumbnail(
                for: cellViewModel.imageURL,
                toFit: currentLayoutSize?.frame ?? .zero,
                cropStrategy: .none
            ) { [weak cell] thumbnail in
                guard let cell else { return }
                DispatchQueue.main.async {
                    UIView.transition(
                        with: cell,
                        duration: 0.3,
                        options: [.transitionCrossDissolve, .allowUserInteraction]
                    ) {
                        cell.imageView.image = thumbnail
                    }
                }
            }
        }
    }
    
    private func applySnapShot(with resources: [HomeContentCellViewModel]) {
        snapShot.append(resources)
        diffableDataSource?.apply(snapShot, to: .main)
    }
    
    // MARK: Action(s)
    
    @objc private func didInvokeRefresh() {
        snapShot.deleteAll()
        viewModel?.onRefresh()
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
            scrollView: collectionView,
            willDisplay: indexPath,
            itemsCount: snapShot.items.count,
            edgeCountInset: 3
        ) {
            viewModel?.onNeedItems()
        }
    }
}
