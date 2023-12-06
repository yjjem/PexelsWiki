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
    
    var viewModel: HomeViewModel?
    
    private var diffableDataSource: DataSource?
    private var snapShot: SnapShot = SnapShot()
    
    private let contentCollectionView: UICollectionView = {
        let collection = UICollectionView(
            frame: .zero,
            collectionViewLayout: .init()
        )
        return collection
    }()
    
    private let contentRefreshControl: UIRefreshControl = UIRefreshControl()
    private let paginationFetchControl: PaginationFetchControl = PaginationFetchControl()
    
    // MARK: Override(s)
    
    override func loadView() {
        super.loadView()
        
        configureView()
        configureContentRefreshControl()
        configureContentCollectionView()
        configurePaginationFetchControl()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel?.loadCuratedPhotosPage()
    }
    
    // MARK: Private Function(s)
    
    private func bindViewModel() {
        
        let mainQueue = DispatchQueue.main
        
        viewModel?.loadedCuratedPhotos = { [weak self] curatedPhotos in
            guard let self else { return }
            let refreshControl = self.contentRefreshControl
            
            let snapShotItems = self.snapShot.items
            let itemsWithoutDuplication = curatedPhotos.filter { !snapShotItems.contains($0) }
            self.applySnapShot(with: itemsWithoutDuplication)
            
            mainQueue.async {
                if refreshControl.isRefreshing {
                    refreshControl.endRefreshing()
                }
            }
        }
    }
    
    private func configureView() {
        view.backgroundColor = .systemGray6
    }
    
    private func configureContentRefreshControl() {
        let refreshAction = #selector(didInvokeRefresh)
        contentRefreshControl.addTarget(self, action: refreshAction, for: .valueChanged)
    }
    
    private func configureContentCollectionView() {
        let portraitLayout = UICollectionViewCompositionalLayout.portraitLayout
        diffableDataSource = makeDataSource()
        addContentCollectionView()
        contentCollectionView.setCollectionViewLayout(portraitLayout, animated: false)
        contentCollectionView.refreshControl = contentRefreshControl
        contentCollectionView.dataSource = diffableDataSource
    }
    
    private func configurePaginationFetchControl() {
        paginationFetchControl.configure(scrollView: contentCollectionView)
        paginationFetchControl.didTriggerFetchMore = { [weak self] in
            self?.viewModel?.loadNextPage()
        }
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
    
    // MARK: Action(s)
    
    @objc
    private func didInvokeRefresh() {
        resetSnapShot()
        viewModel?.resetPage()
    }
}
