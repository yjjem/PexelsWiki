//
//  ImageSearchViewController.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.


import UIKit

protocol PhotolistViewControllerDelegate: AnyObject {
    func didSelectPhotoItem(id: Int)
}

final class PhotoListViewController: UIViewController {
    
    // MARK: Type(s)
    
    typealias PhotoContentCellRegistration = UICollectionView.CellRegistration<PhotoContentCell, PhotoContentCellViewModel>
    typealias DataSource = UICollectionViewDiffableDataSource<Section, PhotoContentCellViewModel>
    typealias SnapShot = NSDiffableDataSourceSectionSnapshot<PhotoContentCellViewModel>
    
    enum Section {
        case main
    }
    
    // MARK: Property(s)
    
    var viewModel: PhotoListViewModel?
    weak var delegate: PhotolistViewControllerDelegate?
    
    private var diffableDataSource: DataSource?
    private var snapShot: SnapShot = SnapShot()
    
    private let imageUtilityManager = ImageUtilityManager(configuration: .defaultConfiguration)
    private let photoCollectionView: UICollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: .init()
    )
    
    // MARK: Override(s)
    
    override func loadView() {
        self.view = photoCollectionView
        photoCollectionView.setCollectionViewLayout(createLayout(), animated: true)
        photoCollectionView.dataSource = diffableDataSource
        photoCollectionView.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        configureDiffableDataSource()
        configureNavigationItem()
        viewModel?.fetchSearchResults()
    }
    
    // MARK: Private Function(s)
    
    private func bindViewModel() {
        viewModel?.loadedPhotoContentCellViewModels = { [weak self] photoResources in
            if let snapShotItems = self?.snapShot.items {
            let itemsWithoutDuplications = photoResources.filter { !snapShotItems.contains($0) }
                self?.updateSnapShot(using: itemsWithoutDuplications)
            }
        }
    }
    
    private func configureDiffableDataSource() {
        let photoContentCellRegistration = makePhotoContentCellRegistration()
        let foundResultsRegistration = makeTotalResultsCountHeader()
        let diffableDataSource = DataSource(collectionView: photoCollectionView) {
            collectionView, indexPath, itemIdentifier in
            
            collectionView.dequeueConfiguredReusableCell(
                using: photoContentCellRegistration,
                for: indexPath,
                item: itemIdentifier
            )
        }
        diffableDataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            collectionView.dequeueConfiguredReusableSupplementary(
                using: foundResultsRegistration,
                for: indexPath
            )
        }
        self.diffableDataSource = diffableDataSource
    }
    
    private func configureNavigationItem() {
        navigationItem.title = viewModel?.currentQuery()
    }
    
    private func makeTotalResultsCountHeader(
    ) -> UICollectionView.SupplementaryRegistration<TotalResultsCountHeader> {
        return UICollectionView.SupplementaryRegistration<TotalResultsCountHeader>(
            elementKind: UICollectionView.elementKindSectionHeader
        ) { [weak self] supplementaryView, kind, indexPath in
            
            supplementaryView.addFoundResultsCount(self?.viewModel?.totalItemsFound ?? 0)
            supplementaryView.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.9)
        }
    }
    
    private func makePhotoContentCellRegistration() -> PhotoContentCellRegistration {
        return PhotoContentCellRegistration { [weak self] cell, indexPath, cellViewModel in
            
            let downscaledSize = cellViewModel.downScaledImageSize(by: 1/7)
            
            cell.imageView.image = nil
            cell.imageView.isOpaque = true
            cell.backgroundColor = .quaternarySystemFill
            cell.imageRequest = self?.imageUtilityManager.requestImage(
                for: cellViewModel.imageURLString
            ) { [weak cell] requestedImage in
                
                requestedImage?.prepareThumbnail(of: downscaledSize) { downscaledImage in
                    guard let cell else { return }
                    DispatchQueue.main.async {
                        UIView.transition(
                            with: cell,
                            duration: 0.3,
                            options: [.transitionCrossDissolve, .allowUserInteraction]
                        ) {
                            cell.imageView.image = downscaledImage
                        }
                    }
                }
            }
        }
    }
    
    private func updateSnapShot(using photoList: [PhotoContentCellViewModel]) {
        snapShot.append(photoList)
        diffableDataSource?.apply(snapShot, to: .main)
    }
    
    // MARK: Compositional Layout
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        
        let defaultInset = NSDirectionalEdgeInsets(top: 1, leading: 1, bottom: 1, trailing: 1)
        
        let tripleHorizontalItem = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1/3),
                heightDimension: .fractionalWidth(1/3)
            )
        )
        tripleHorizontalItem.contentInsets = defaultInset
        
        let tripleHorizontalGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(3/9)
            ),
            repeatingSubitem: tripleHorizontalItem,
            count: 3
        )
        
        let mainHalfItem = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(2/3),
                heightDimension: .fractionalWidth(2/3)
            )
        )
        mainHalfItem.contentInsets = defaultInset
        
        let halfDoubleItem = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(0.5)
            )
        )
        halfDoubleItem.contentInsets = defaultInset
        
        let stackedDoubleGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1/3),
                heightDimension: .fractionalHeight(1.0)
            ),
            repeatingSubitem: halfDoubleItem,
            count: 2
        )
        
        let mainToLeadingGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalWidth(6/9)
            ),
            subitems: [mainHalfItem, stackedDoubleGroup]
        )
        
        let mainToTrailingGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalWidth(6/9)
            ),
            subitems: [stackedDoubleGroup, mainHalfItem]
        )
        
        let topGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1/2)
            ),
            subitems: [mainToLeadingGroup, tripleHorizontalGroup]
        )
        
        let bottomGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1/2)
            ),
            subitems: [mainToTrailingGroup, tripleHorizontalGroup]
        )

        let nestedGroup = NSCollectionLayoutGroup.vertical(
          layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(18/9)),
          subitems: [topGroup, bottomGroup]
        )
        
        let resultsHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(5)
            ),
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        resultsHeader.pinToVisibleBounds = true
        
        let section = NSCollectionLayoutSection(group: nestedGroup)
        section.boundarySupplementaryItems = [resultsHeader]
        section.contentInsets = .init(top: 15, leading: 15, bottom: 15, trailing: 15)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
}

// MARK: UICollectionViewDelegate

extension PhotoListViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let selectedItem = diffableDataSource?.itemIdentifier(for: indexPath) {
            delegate?.didSelectPhotoItem(id: selectedItem.imageID)
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        if needFetchMore(
            scrollView: collectionView,
            willDisplay: indexPath,
            itemsCount: snapShot.items.count,
            edgeCountInset: 50
        ) {
            viewModel?.fetchNextPage()
        }
    }
}

