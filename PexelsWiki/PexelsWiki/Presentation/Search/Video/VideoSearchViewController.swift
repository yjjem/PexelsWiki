//
//  VideoSearchViewController.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.
    

import UIKit

final class VideoSearchViewController: UIViewController {
    
    typealias VideoContentCellRegistration = UICollectionView.CellRegistration<VideoContentCell, VideoResource>
    typealias DataSource = UICollectionViewDiffableDataSource<Section, VideoResource>
    typealias SnapShot = NSDiffableDataSourceSectionSnapshot<VideoResource>
    
    enum Section {
        case main
    }
    
    var viewModel: VideoSearchViewModel?
    
    private var diffableDataSource: DataSource?
    private var snapShot: SnapShot = SnapShot()
    
    private let videoCollectionView: UICollectionView = {
       let collection = UICollectionView(
        frame: .zero,
        collectionViewLayout: .init()
       )
        return collection
    }()
    
    override func loadView() {
        super.loadView()
        configureNavigationItem()
        configureVideoCollectionView()
        
        if let viewModel {
            addNavigationTitle(viewModel.query)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel?.loadSearchResults()
    }
    
    private func addNavigationTitle(_ title: String) {
        navigationItem.title = title
    }
    
    private func configureNavigationItem() {
        let filterButtonItem = UIBarButtonItem(
            image: .init(systemName: "line.3.horizontal.decrease.circle"),
            style: .plain,
            target: self,
            action: #selector(didTapFilterButton)
        )
        navigationItem.rightBarButtonItem = filterButtonItem
    }
    
    private func makeFilterView(
        with viewModel: SearchFilterViewModel
    ) -> SearchFilterViewController {
        
        let filterView = SearchFilterViewController()
        filterView.viewModel = viewModel
        filterView.delegate = self
        
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
        
        present(navigation, animated: true)
    }
    
    private func bindViewModel() {
        guard let viewModel else { return }

        viewModel.loadedVideoResources = { [weak self] videoResource in
            
            guard let self else { return }
            
            let snapShotItems = self.snapShot.items
            let itemsWithoutDuplications = videoResource.filter { !snapShotItems.contains($0) }
            self.updateSnapShot(using: itemsWithoutDuplications)
        }
    }
    
    private func configureVideoCollectionView() {
        diffableDataSource = makeDiffableDataSource()
        addVideoCollectionView()
        videoCollectionView.dataSource = diffableDataSource
        videoCollectionView.delegate = self
        videoCollectionView.setCollectionViewLayout(
            UICollectionViewCompositionalLayout.landscapeLayout,
            animated: false
        )
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
    
    private func makeDiffableDataSource() -> DataSource {
        let videoContentCellRegistration = makeVideoContentCellRegistration()
        
        let diffableDataSource = DataSource(collectionView: videoCollectionView) {
            collectionView, indexPath, itemIdentifier in
            
            collectionView.dequeueConfiguredReusableCell(
                using: videoContentCellRegistration,
                for: indexPath,
                item: itemIdentifier
            )
        }
        
        return diffableDataSource
    }
    
    private func updateSnapShot(using videoList: [VideoResource]) {
        snapShot.append(videoList)
        diffableDataSource?.apply(snapShot, to: .main)
    }
    
    private func resetSnapShot() {
        snapShot.deleteAll()
    }
    
    private func addVideoCollectionView() {
        view.addSubview(videoCollectionView)
        
        videoCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            videoCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            videoCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            videoCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            videoCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension VideoSearchViewController: SearchFilterViewControllerDelegate {
    
    func didApplyFilterOptions(_ options: FilterOptions) {
        guard let viewModel else { return }
        
        resetSnapShot()
        viewModel.apply(filter: options)
        
        switch viewModel.orientation {
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
        
        viewModel.resetPage()
    }
}

extension VideoSearchViewController: UICollectionViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let paginationPoint = scrollView.contentSize.height - scrollView.bounds.height
        let offset = scrollView.contentOffset.y

        if paginationPoint < offset {
            viewModel?.loadNextPage()
        }
    }
    
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


