//
//  VideoSearchViewController.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.


import UIKit

protocol VideoListViewControllerDelegate: AnyObject {
    func didSelectVideoItem(id: Int)
}

final class VideoListViewController: UIViewController {
    
    // MARK: Type(s)
    
    typealias VideoContentCellRegistration = UICollectionView.CellRegistration<VideoContentCell, VideoCellViewModel>
    typealias DataSource = UICollectionViewDiffableDataSource<Section, VideoCellViewModel>
    typealias SnapShot = NSDiffableDataSourceSectionSnapshot<VideoCellViewModel>
    
    enum Section {
        case main
    }
    
    // MARK: Property(s)
    
    var viewModel: VideoListViewModel?
    weak var delegate: VideoListViewControllerDelegate?
    
    private var diffableDataSource: DataSource?
    private var snapShot: SnapShot = SnapShot()
    
    private let imageUtilityManager = ImageUtilityManager()
    private let videoCollectionView: UICollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: .init()
    )
    
    // MARK: Override(s)
    
    override func loadView() {
        self.view = videoCollectionView
        videoCollectionView.setCollectionViewLayout(makeCompositionalLayout(), animated: false)
        videoCollectionView.dataSource = diffableDataSource
        videoCollectionView.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        configureDiffableDataSource()
        configureNavigationItem()
        viewModel?.onNeedItems()
    }
    
    // MARK: Private Function(s)
    
    private func bindViewModel() {
        viewModel?.fetchedVideoCellViewModelList = { [weak self] videoPreviewItem in
            guard let items = self?.snapShot.items else { return }
            let itemsWithoutDuplications = videoPreviewItem.filter { !items.contains($0) }
            self?.updateSnapShot(using: itemsWithoutDuplications)
        }
    }
    
    private func makeCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1/3),
            heightDimension: .fractionalWidth(1/3 * 1.9)
        )
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: itemSize.heightDimension
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            repeatingSubitem: item,
            count: 3
        )
        group.interItemSpacing = .fixed(1.5)
        
        let resultsHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(5)
            ),
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        resultsHeader.pinToVisibleBounds = true
        
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [resultsHeader]
        section.contentInsets = .init(top: 15, leading: 15, bottom: 15, trailing: 15)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    private func configureDiffableDataSource() {
        let videoContentCellRegistration = makeVideoContentCellRegistration()
        let totalResultsHeaderRegistration = makeTotalResultsCountHeader()
        let diffableDataSource = DataSource(collectionView: videoCollectionView) {
            collectionView, indexPath, itemIdentifier in
            
            collectionView.dequeueConfiguredReusableCell(
                using: videoContentCellRegistration,
                for: indexPath,
                item: itemIdentifier
            )
        }
        
        diffableDataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            collectionView.dequeueConfiguredReusableSupplementary(
                using: totalResultsHeaderRegistration,
                for: indexPath
            )
        }
        self.diffableDataSource = diffableDataSource
    }
    
    private func makeVideoContentCellRegistration() -> VideoContentCellRegistration {
        return VideoContentCellRegistration { [weak self]  cell, indexPath, videoPreviewItem in
            
            cell.videoThumbnailView.isOpaque = true
            cell.videoThumbnailView.image = nil
            cell.backgroundColor = .quaternarySystemFill
            cell.durationLabel.text = videoPreviewItem.duration
            cell.imageRequest = self?.imageUtilityManager.thumbnail(
                for: videoPreviewItem.thumbnailImage,
                toFit: cell.frame,
                cropStrategy: .centerPreserverRatio
            ) { [weak cell] thumbnail in
                guard let cell else { return }
                DispatchQueue.main.async {
                    UIView.transition(
                        with: cell,
                        duration: 0.3,
                        options: [.allowUserInteraction, .transitionCrossDissolve]
                    ) {
                        cell.videoThumbnailView.image  = thumbnail
                    }
                }
            }
        }
    }
    
    private func makeTotalResultsCountHeader(
    ) -> UICollectionView.SupplementaryRegistration<TotalResultsCountHeader> {
        return UICollectionView.SupplementaryRegistration<TotalResultsCountHeader>(
            elementKind: UICollectionView.elementKindSectionHeader
        ) { [weak self] supplementaryView, kind, indexPath in
            guard let self else { return }
            
            supplementaryView.addFoundResultsCount(self.viewModel?.totalItemsFound ?? 0)
            supplementaryView.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.9)
        }
    }
    
    private func updateSnapShot(using cellViewModels: [VideoCellViewModel]) {
        snapShot.append(cellViewModels)
        diffableDataSource?.apply(snapShot, to: .main)
    }
    
    private func configureNavigationItem() {
        navigationItem.title = viewModel?.currentQuery()
    }
}

// MARK: UICollectionViewDelegate

extension VideoListViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let selectedItem = diffableDataSource?.itemIdentifier(for: indexPath) {
            delegate?.didSelectVideoItem(id: selectedItem.id)
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
            edgeCountInset: 20
        ) {
            viewModel?.onNeedItems()
        }
    }
}
