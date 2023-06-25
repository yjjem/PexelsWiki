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
        configurePhotoCollectionView()
        bindViewModel()
    }
    
    private func addNavigationTitle(_ title: String) {
        navigationItem.title = title
    }
    
    private func bindViewModel() {
        guard let viewModel else { return }

        addNavigationTitle(viewModel.query)
        viewModel.loadSearchResults()
        viewModel.loadedVideoResources = { [weak self] videoResource in
            self?.updateSnapShot(using: videoResource)
        }
    }
    
    private func configurePhotoCollectionView() {
        diffableDataSource = makeDiffableDataSource()
        addVideoCollectionView()
        videoCollectionView.dataSource = diffableDataSource
        videoCollectionView.delegate = self
        videoCollectionView.setCollectionViewLayout(.landscapeLayout, animated: false)
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
        let photoContentCellRegistration = makeVideoContentCellRegistration()
        
        let diffableDataSource = DataSource(collectionView: videoCollectionView) {
            collectionView, indexPath, itemIdentifier in
            
            collectionView.dequeueConfiguredReusableCell(
                using: photoContentCellRegistration,
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


