//
//  ViewController.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.


import UIKit

final class HomeViewController: UIViewController {
    
    typealias ContentCellRegistration = UICollectionView.CellRegistration<HomeContentCell, PhotoResource>
    typealias DataSource = UICollectionViewDiffableDataSource<Section, PhotoResource>
    typealias SnapShot = NSDiffableDataSourceSectionSnapshot<PhotoResource>
    
    enum Section {
        case main
    }
    
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
    
    override func loadView() {
        super.loadView()
        
        configureView()
        addContentCollectionView()
        configureContentCollectionView()
        bindViewModel()
    }
    
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
    
    private func configureContentCollectionView() {
        
        let contentCollectionViewLayout = makeContentCollectionViewLayout()
        diffableDataSource = makeDataSource()
        contentCollectionView.dataSource = diffableDataSource
        contentCollectionView.delegate = self
        contentCollectionView.setCollectionViewLayout(contentCollectionViewLayout, animated: false)
        contentCollectionView.refreshControl = makeCollectionViewRefreshControl()
    }
    
    private func makeContentCellRegistration() -> ContentCellRegistration {
        
        let registration = ContentCellRegistration { cell, indexPath, photoResource in
            
            let imageURL = photoResource.url["portrait"]!
            
            let viewModel = HomeContentCellViewModel(
                userName: photoResource.photographer,
                userProfileURL: photoResource.photographerURL,
                imageURL: imageURL
            )
            
            cell.configure(using: viewModel)
        }
        
        return registration
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
    
    private func resetSnapShot() {
        snapShot.deleteAll()
    }
    
    private func applySnapShot(with resources: [PhotoResource]) {
        snapShot.append(resources)
        diffableDataSource?.apply(snapShot, to: .main)
    }
    
    private func makeContentCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(5/3)
        )
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .none
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    private func makeCollectionViewRefreshControl() -> UIRefreshControl {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(didRefresh), for: .valueChanged)
        return refreshControl
    }
    
    @objc
    private func didRefresh() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.resetSnapShot()
            self.viewModel?.resetPage()
            self.contentCollectionView.refreshControl?.endRefreshing()
        }
    }
}

extension HomeViewController: UICollectionViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let paginationPoint = scrollView.contentSize.height - scrollView.bounds.height
        let offset = scrollView.contentOffset.y

        if paginationPoint < offset {
            viewModel?.loadNextPage()
        }
    }
}
