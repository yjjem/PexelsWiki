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
        viewModel?.fetchSearchResults()
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
        
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    private func configureDiffableDataSource() {
        let videoContentCellRegistration = makeVideoContentCellRegistration()
        let diffableDataSource = DataSource(collectionView: videoCollectionView) {
            collectionView, indexPath, itemIdentifier in
            
            collectionView.dequeueConfiguredReusableCell(
                using: videoContentCellRegistration,
                for: indexPath,
                item: itemIdentifier
            )
        }
        self.diffableDataSource = diffableDataSource
    }
    
    private func makeVideoContentCellRegistration() -> VideoContentCellRegistration {
        let registration = VideoContentCellRegistration { cell, indexPath, videoPreviewItem in
            cell.configure(using: videoPreviewItem)
        }
        return registration
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
            edgeCountInset: 9
        ) {
            viewModel?.fetchNextPage()
        }
    }
}
