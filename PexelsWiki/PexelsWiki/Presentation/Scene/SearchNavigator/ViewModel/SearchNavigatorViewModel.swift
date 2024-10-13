//
//  PexelsSearchViewModel.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.

import Foundation


final class SearchNavigatorViewModel {
    
    // MARK: Property(s)
    
    var loadedFeaturedCollectionKeywords: (([FeaturedCollectionCellViewModel]) -> Void)?
    var cancelToken: Cancellable?
    
    private var query: String = ""
    
    private let useCase: DiscoverFeaturedCollectionsUseCase
    
    init(useCase: DiscoverFeaturedCollectionsUseCase) {
        self.useCase = useCase
    }
    
    // MARK: Function(s)
    
    func updateQuery(_ newQuery: String) {
        self.query = newQuery
    }
    
    func currentQuery() -> String {
        return query
    }
    
    func shuffledCategories() -> [RecommendedCategoryCellViewModel] {
        return RecommendedCategoryCellViewModel.allCases.shuffled()
    }
    
    func onViewDidLoad() {
        let command = DiscoverFeaturedCollectionsCommand(requiresRefresh: false)
        cancelToken = useCase.discoverFeaturedCollections(command) { [weak self] response in
            guard case .success(let featuredCollection) = response else {
                return
            }
            
            let mappedViewModels = featuredCollection.collections.map {
                return FeaturedCollectionCellViewModel(
                    identifier: $0.id,
                    title: $0.title,
                    description: $0.description,
                    totalItems: $0.mediaCount
                )
            }
            
            DispatchQueue.main.async {
                self?.loadedFeaturedCollectionKeywords?(mappedViewModels)
            }
        }
    }
}
