//
//  ViewController.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.


import UIKit

final class HomeViewController: UIViewController {
    
    typealias ContentCellRegistration = UICollectionView.CellRegistration<HomeContentCell, PhotoResource>
    typealias DataSource = UICollectionViewDiffableDataSource<Section, PhotoResource>
    typealias SnapShot = NSDiffableDataSourceSnapshot<Section, PhotoResource>
    
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
    private var snapShot: SnapShot?
    
    override func loadView() {
        super.loadView()
        
        configureView()
        addContentCollectionView()
        configureContentCollectionView()
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
        contentCollectionView.setCollectionViewLayout(contentCollectionViewLayout, animated: false)
    }
    
    private func makeContentCellRegistration() -> ContentCellRegistration {
        
        let registration = ContentCellRegistration { cell, indexPath, photoResource in
            
            // TODO: Configure Cell
            
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
    
    private func applySnapShot(with resources: [PhotoResource]) {
        
        var snapShot = SnapShot()
        snapShot.appendSections([.main])
        snapShot.appendItems(resources)
        diffableDataSource?.apply(snapShot)
    }
    
    private func makeContentCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(4/3)
        )
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .none
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
}

