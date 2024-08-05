//
//  DiscoverFeaturedCollectionKeywordsService.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.
    

final class DiscoverFeaturedCollectionKeywordsService: DiscoverFeaturedCollectionKeywordsUseCase {
    
    // MARK: Property(s)
    
    private let port: FetchFeaturedCollectionKeywordsPort
    
    init(port: FetchFeaturedCollectionKeywordsPort) {
        self.port = port
    }
    
    // MARK: Function(s)
    
    func featuredCollectionKeywords(
        _ completion: @escaping (Result<[FeaturedCollectionKeyword], DiscoverFeaturedCollectionKeywordsUseCaseError>) -> Void
    ) {
        port.fetchFeaturedCollectionKeywords { fetchResult in
            completion(fetchResult)
        }
    }
}
