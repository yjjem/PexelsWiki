//
//  VideoSearchViewController.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.
    

import UIKit

final class VideoSearchViewController: UIViewController {
    
    // MARK: Type(s)
    
    typealias VideoContentCellRegistration = UICollectionView.CellRegistration<VideoContentCell, VideoResource>
    typealias DataSource = UICollectionViewDiffableDataSource<Section, VideoResource>
    typealias SnapShot = NSDiffableDataSourceSectionSnapshot<VideoResource>
    
    enum Section {
        case main
    }
    
    // MARK: Variable(s)
    
    var viewModel: VideoSearchViewModel?
    
    private var diffableDataSource: DataSource?
    private var snapShot: SnapShot = SnapShot()
    
    private let paginationFetchControl: PaginationFetchControl = PaginationFetchControl()
    private let videoCollectionView: UICollectionView = {
       let collection = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewCompositionalLayout.landscapeLayout
       )
        return collection
    }()
    
    // MARK: Override(s)
    
    override func loadView() {
        self.view = videoCollectionView
        videoCollectionView.dataSource = diffableDataSource
        videoCollectionView.delegate = self
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
        guard let viewModel else { return }

        viewModel.loadedVideoResources = { [weak self] videoResource in
            guard let self else { return }
            
            let snapShotItems = self.snapShot.items
            let itemsWithoutDuplications = videoResource.filter { !snapShotItems.contains($0) }
            self.updateSnapShot(using: itemsWithoutDuplications)
        }
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
        let registration = VideoContentCellRegistration { cell, indexPath, videoResource in
            let videoURLString = videoResource.videoFiles[0].link
            let userName = videoResource.user.name
            let viewModel = VideoContentCellViewModel(
                videoURLString: videoURLString,
                userName: userName
            )
            cell.configure(using: viewModel)
        }
        return registration
    }
    
    private func updateSnapShot(using videoList: [VideoResource]) {
        snapShot.append(videoList)
        diffableDataSource?.apply(snapShot, to: .main)
    }
    
    private func resetSnapShot() {
        snapShot.deleteAll()
    }
    
    private func configureNavigationItem() {
        let filterButtonItem = UIBarButtonItem(
            image: .init(systemName: "line.3.horizontal.decrease.circle"),
            style: .plain,
            target: self,
            action: #selector(didTapFilterButton)
        )
        navigationItem.rightBarButtonItem = filterButtonItem
        navigationItem.title = viewModel?.query
    }
    
    private func makeFilterView(
        with viewModel: SearchFilterViewModel
    ) -> SearchFilterViewController {
        
        let filterView = SearchFilterViewController()
        filterView.viewModel = viewModel
        filterView.delegate = self
        // TODO: 분리
        return filterView
    }
    
    @objc func didTapFilterButton() {
        guard let viewModel else { return }
        let filterViewModel = SearchFilterViewModel(
            selectedOrientation: viewModel.orientation,
            selectedSize: viewModel.size
        )
        let filterView = makeFilterView(with: filterViewModel)
        let navigation = UINavigationController(rootViewController: filterView)
        navigation.navigationBar.prefersLargeTitles = true
        // TODO: presentation 분리
        present(navigation, animated: true)
    }
}

// MARK: SearchFilterViewControllerDelegate

extension VideoSearchViewController: SearchFilterViewControllerDelegate {
    
    private func adaptLayout(orientation: ContentOrientation) {
        switch orientation {
        case .landscape:
            videoCollectionView.setCollectionViewLayout(
                UICollectionViewCompositionalLayout.landscapeLayout,
                animated: true
            )
        case .portrait:
            videoCollectionView.setCollectionViewLayout(
                UICollectionViewCompositionalLayout.portraitLayout,
                animated: true
            )
        case .square:
            videoCollectionView.setCollectionViewLayout(
                UICollectionViewCompositionalLayout.squareLayout,
                animated: true
            )
        }
    }
    
    func didApplyFilterOptions(_ options: FilterOptions) {
        guard let viewModel else { return }
        
        resetSnapShot()
        viewModel.apply(filter: options)
        adaptLayout(orientation: viewModel.orientation)
        viewModel.resetPage()
    }
}

// MARK: UICollectionViewDelegate

extension VideoSearchViewController: UICollectionViewDelegate {
    
    func collectionView(
        _ collectionView: UICollectionView,
        willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        if let cell = cell as? VideoContentCell {
            cell.play()
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didEndDisplaying cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        if let cell = cell as? VideoContentCell {
            cell.pause()
        }
    }
}


