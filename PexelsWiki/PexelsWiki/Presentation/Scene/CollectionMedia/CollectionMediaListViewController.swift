//
//  CollectionMediaListViewController.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.


import UIKit

final class CollectionMediaListViewController: UIViewController {
    
    // MARK: Property(s)
    
    var viewModel: MediaCollectionViewModel?
    
    private var dataSource: CollectionMediaDataSource?
    private let collectionView: UICollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: .init()
    )
    
    // MARK: Function(s)
    
    override func loadView() {
        self.view = collectionView
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
        let configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        return UICollectionViewCompositionalLayout.list(using: configuration)
    }
}
