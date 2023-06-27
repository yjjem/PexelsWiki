//
//  ViewController.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.


import UIKit

final class HomeViewController: UIViewController {
    
    // MARK: Type(s)
    
    typealias ContentCellRegistration = UICollectionView.CellRegistration<HomeContentCell, PhotoResource>
    typealias DataSource = UICollectionViewDiffableDataSource<Section, PhotoResource>
    typealias SnapShot = NSDiffableDataSourceSectionSnapshot<PhotoResource>
    
    enum Section {
        case main
    }
    
    // MARK: Variable(s)
    
    private let contentCollectionView: UICollectionView = {
        let collection = UICollectionView(
            frame: .zero,
            collectionViewLayout: .init()
        )
        return collection
    }()
    
    private var diffableDataSource: DataSource?
    private var snapShot: SnapShot = SnapShot()
    
    var viewModel: HomeViewModel?
    
    // MARK: Override(s)
    
    override func loadView() {
        super.loadView()
        
        configureView()
        configureContentCollectionView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
    }
    
    // MARK: Private Function(s)
    
    private func bindViewModel() {
        guard let viewModel else { return }
        
        viewModel.loadCuratedPhotosPage()
        viewModel.loadedCuratedPhotos = { [weak self] curatedPhotos in
            self?.applySnapShot(with: curatedPhotos)
        }
    }
    
    private func configureView() {
        view.backgroundColor = .systemGray6
    }
    
    private func configureContentCollectionView() {
        
        addContentCollectionView()
        diffableDataSource = makeDataSource()
        
        contentCollectionView.setCollectionViewLayout(.portraitLayout, animated: false)
        contentCollectionView.refreshControl = makeCollectionViewRefreshControl()
        contentCollectionView.dataSource = diffableDataSource
        contentCollectionView.delegate = self
    }
    
    private func addContentCollectionView() {
        
        view.addSubview(contentCollectionView)
        
        contentCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            contentCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            contentCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func makeDataSource() -> DataSource {
        
        let contentCellRegistration = makeContentCellRegistration()
        
        let diffableDataSource = DataSource(collectionView: contentCollectionView) {
            collectionView, indexPath, viewModel in
            
            collectionView.dequeueConfiguredReusableCell(
                using: contentCellRegistration,
                for: indexPath,
                item: viewModel
            )
        }
        
        return diffableDataSource
    }
    
    private func makeContentCellRegistration() -> ContentCellRegistration {
        return ContentCellRegistration { cell, indexPath, photoResource in
            
            let imageURL = photoResource.url["portrait"]!
            let viewModel = HomeContentCellViewModel(
                userName: photoResource.photographer,
                userProfileURL: photoResource.photographerURL,
                imageURL: imageURL
            )
            
            cell.configure(using: viewModel)
        }
    }
    
    private func applySnapShot(with resources: [PhotoResource]) {
        snapShot.append(resources)
        diffableDataSource?.apply(snapShot, to: .main)
    }
    
    private func resetSnapShot() {
        snapShot.deleteAll()
    }
    
    private func makeCollectionViewRefreshControl() -> UIRefreshControl {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(didInvokeRefresh), for: .valueChanged)
        return refreshControl
    }
    
    // MARK: Action(s)
    
    @objc
    private func didInvokeRefresh() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.resetSnapShot()
            self.viewModel?.resetPage()
            self.contentCollectionView.refreshControl?.endRefreshing()
        }
    }
}

// MARK: UICollectionViewDelegate

extension HomeViewController: UICollectionViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let verticalPaginationTriggerPoint = scrollView.contentSize.height - scrollView.bounds.height
        let currentYPosition = scrollView.contentOffset.y

        if currentYPosition > verticalPaginationTriggerPoint {
            viewModel?.loadNextPage()
        }
    }
}
