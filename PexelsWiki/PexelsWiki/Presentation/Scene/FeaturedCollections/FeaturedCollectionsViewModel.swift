//
//  FeaturedCollectionsViewModel.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.


import UIKit

final class FeaturedCollectionsViewModel {
    
    // MARK: Property(s)
    
    var allCollectionKeywords: [CollectionKeyword] = []
    var receivedCollectionKeywords: (([CollectionKeyword]) -> Void)?
    
    // MARK: Private Property(s)
    
    private let useCase: DiscoverFeaturedCollectionsUseCase
    private var cancelToken: Cancellable?
    
    init(useCase: DiscoverFeaturedCollectionsUseCase) {
        self.useCase = useCase
        retrieveInitialCollectionKeywords()
    }
    
    // MARK: Function(s)
    
    private func retrieveInitialCollectionKeywords() {
        let initialRetrievalCommand = DiscoverFeaturedCollectionsCommand(requiresRefresh: false)
        cancelToken = useCase.discoverFeaturedCollections(initialRetrievalCommand) {
            [weak self] response in
            
            guard case .success(let collectionResources) = response else {
                return
            }
            
            let collectionKeywords = collectionResources
                .map { CollectionKeyword(title: $0.title, totalItems: $0.mediaCount) }
            self?.receivedCollectionKeywords?(collectionKeywords)
        }
    }
    
    func onViewDidLoad() {
        retrieveInitialCollectionKeywords()
    }
    
    func onRefresh() {
        cancelToken?.cancel()
        allCollectionKeywords.removeAll()
        retrieveInitialCollectionKeywords()
    }
}
