//
//  FeaturedCollectionKeywordsListViewModel.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.


import UIKit

final class FeaturedCollectionsListViewModel {
    
    // MARK: Property(s)
    
    var loadedFeaturedCollections: (([FeaturedCollectionCellViewModel]) -> Void)?
    
    // MARK: Private Property(s)
    
    private var cancelToken: Cancellable?
    
    private let useCase: DiscoverFeaturedCollectionsUseCase
    
    init(useCase: DiscoverFeaturedCollectionsUseCase) {
        self.useCase = useCase
    }
    
    // MARK: Function(s)
    
    func onViewDidLoad() {
        retrieveInitialFeaturedCollections()
    }
    
    func onRefresh() {
        cancelToken?.cancel()
        retrieveInitialFeaturedCollections()
    }
    
    // MARK: Private Function(s)
    
    private func retrieveInitialFeaturedCollections() {
        let initialRetrievalCommand = DiscoverFeaturedCollectionsCommand(requiresRefresh: false)
        cancelToken = useCase.discoverFeaturedCollections(initialRetrievalCommand) {
            [weak self] response in
            
            guard case .success(let collectionResources) = response else {
                return
            }
            
            let featuredCollections = collectionResources.collections
                .map {
                    return FeaturedCollectionCellViewModel(
                        title: $0.title,
                        description: $0.description,
                        totalItems: $0.mediaCount
                    )
                }
            self?.loadedFeaturedCollections?(featuredCollections)
        }
    }
}
