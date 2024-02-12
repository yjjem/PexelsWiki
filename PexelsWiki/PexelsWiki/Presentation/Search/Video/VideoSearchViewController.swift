//
//  VideoSearchViewController.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.
    

import UIKit

final class VideoSearchViewController: UIViewController {
    
    // MARK: Type(s)
    
    typealias VideoContentCellRegistration = UICollectionView.CellRegistration<VideoContentCell, VideoPreviewItem>
    typealias DataSource = UICollectionViewDiffableDataSource<Section, VideoPreviewItem>
    typealias SnapShot = NSDiffableDataSourceSectionSnapshot<VideoPreviewItem>
    
    enum Section {
        case main
    }
    
    // MARK: Variable(s)
    
    var viewModel: VideoSearchViewModel?
    
    private var diffableDataSource: DataSource?
    private var snapShot: SnapShot = SnapShot()
    
    private let paginationFetchControl: PaginationFetchControl = PaginationFetchControl()
    private let videoCollectionView: UICollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: .init()
    )
    
    // MARK: Override(s)
    
    override func loadView() {
        self.view = videoCollectionView
        videoCollectionView.dataSource = diffableDataSource
        videoCollectionView.setCollectionViewLayout(makeCompositionalLayout(), animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        configureDiffableDataSource()
        configureNavigationItem()
        configurePaginationFetchControl()
        viewModel?.fetchSearchResults()
    }
    
    // MARK: Private Function(s)
    
    private func bindViewModel() {
        viewModel?.fetchedVideoPreviewItems = { [weak self] videoPreviewItem in
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
        group.interItemSpacing = .fixed(5)

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
    
    private func configurePaginationFetchControl() {
        paginationFetchControl.configure(scrollView: videoCollectionView)
        paginationFetchControl.didTriggerFetchMore = { [weak self] in
            self?.viewModel?.fetchNextPage()
        }
    }
    
    private func makeVideoContentCellRegistration() -> VideoContentCellRegistration {
        let registration = VideoContentCellRegistration { cell, indexPath, videoPreviewItem in
            cell.configure(using: videoPreviewItem)
        }
        return registration
    }
    
    private func updateSnapShot(using videoList: [VideoPreviewItem]) {
        snapShot.append(videoList)
        diffableDataSource?.apply(snapShot, to: .main)
    }
    
    private func configureNavigationItem() {
        navigationItem.title = viewModel?.currentQuery()
    }
}
