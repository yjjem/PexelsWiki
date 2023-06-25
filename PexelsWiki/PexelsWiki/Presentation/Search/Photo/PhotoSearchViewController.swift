//
//  ImageSearchViewController.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.
    

import UIKit

final class PhotoSearchViewController: UIViewController {
    
    typealias PhotoContentCellRegistartion = UICollectionView.CellRegistration<PhotoContentCell, PhotoResource>
    typealias DataSource = UICollectionViewDiffableDataSource<Section, PhotoResource>
    typealias SnapShot = NSDiffableDataSourceSectionSnapshot<PhotoResource>
    
    enum Section {
        case main
    }
    
    var viewModel: PhotoSearchViewModel?
    
    private var diffableDataSource: DataSource?
    private var snapShot: SnapShot = SnapShot()
    
    private let photoCollectionView: UICollectionView = {
       let collection = UICollectionView(
        frame: .zero,
        collectionViewLayout: .init()
       )
        return collection
    }()
    
    override func loadView() {
        super.loadView()
        
        configurePhotoCollectionView()
    }
    
    private func bindViewModel() {
        guard let viewModel else { return }
        
        viewModel.loadSearchResults()
        viewModel.loadedPhotoResources = { [weak self] photoResources in
            self?.updateSnapShot(using: photoResources)
        }
    }
    
    private func configurePhotoCollectionView() {
        diffableDataSource = makeDiffableDataSource()
        
        addPhotoCollectionView()
        photoCollectionView.dataSource = diffableDataSource
        photoCollectionView.setCollectionViewLayout(.squareLayout, animated: false)
    }
    
    private func makePhotoContentCellRegistration() -> PhotoContentCellRegistartion {
        let registration = PhotoContentCellRegistartion { cell, indexPath, photoResource in
            
            let viewModel = PhotoContentCellViewModel(
                imageURLString: photoResource.url["portrait"]!,
                userName: photoResource.photographer
            )
            
            cell.configure(using: viewModel)
        }
        return registration
    }
    
    private func makeDiffableDataSource() -> DataSource {
        let photoContentCellRegistration = makePhotoContentCellRegistration()
        
        let diffableDataSource = DataSource(collectionView: photoCollectionView) {
            collectionView, indexPath, itemIdentifier in
            
            collectionView.dequeueConfiguredReusableCell(
                using: photoContentCellRegistration,
                for: indexPath,
                item: itemIdentifier
            )
        }
        
        return diffableDataSource
    }
    
    private func updateSnapShot(using photoList: [PhotoResource]) {
        snapShot.append(photoList)
        diffableDataSource?.apply(snapShot, to: .main)
    }
    
    private func resetSnapShot() {
        snapShot.deleteAll()
    }
    
    private func addPhotoCollectionView() {
        view.addSubview(photoCollectionView)
        
        photoCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            photoCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            photoCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            photoCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            photoCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
