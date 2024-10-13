//
//  CollectionMediaListViewController.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.


import UIKit

protocol CollectionMediaListViewControllerDelegate {
    func didSelectPreviewItem(_ previewItem: MediaCollectionViewModel.MediaPreview)
}

final class CollectionMediaListViewController: UIViewController {
    
    // MARK: Property(s)
    
    var viewModel: MediaCollectionViewModel?
    var delegate: CollectionMediaListViewControllerDelegate?
    
    private var dataSource: CollectionMediaDataSource?
    private let collectionView: UICollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: .init()
    )
    
    // MARK: Function(s)
    
    override func loadView() {
        self.view = collectionView
        collectionView.delegate = self
        collectionView.collectionViewLayout = createCompositionalLayout()
        dataSource = CollectionMediaDataSource(collectionView: collectionView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        viewModel?.onViewDidLoad()
    }
    
    // MARK: Private Function(s)
    
    private func bindViewModel() {
        viewModel?.loadedMediaPreviews = { [weak self] mediaPreviewItems in
            self?.dataSource?.addMediaItems(mediaPreviewItems)
        }
    }
    
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let cellContentItem = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1/3),
                heightDimension: .fractionalWidth(1/3)
            )
        )
        
        let defaultGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: cellContentItem.layoutSize.heightDimension
            ),
            repeatingSubitem: cellContentItem,
            count: 3
        )
        defaultGroup.interItemSpacing = NSCollectionLayoutSpacing.fixed(2)
        
        let section = NSCollectionLayoutSection(group: defaultGroup)
        section.interGroupSpacing = 0.5
        section.contentInsets = .init(top: 2, leading: 2, bottom: 2, trailing: 2)
        return UICollectionViewCompositionalLayout(section: section)
        
    }
}

extension CollectionMediaListViewController: UICollectionViewDelegate {
    
    func collectionView(
        _ collectionView: UICollectionView,
        willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        if needFetchMore(
            scrollView: collectionView, 
            willDisplay: indexPath,
            itemsCount: dataSource?.totalNumberOfItems ?? .zero,
            edgeCountInset: 5
        ) {
            viewModel?.onNeedMoreItems()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let selectedPreviewItem = dataSource?.item(at: indexPath) {
            delegate?.didSelectPreviewItem(selectedPreviewItem)
        }
    }
}
