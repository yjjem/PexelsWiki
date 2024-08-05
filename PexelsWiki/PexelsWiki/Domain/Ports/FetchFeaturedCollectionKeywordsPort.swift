//
//  FetchFeaturedCollectionKeywordsPort.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.
    

protocol FetchFeaturedCollectionKeywordsPort {
    
    func fetchFeaturedCollectionKeywords(
        _ completion: @escaping (Result<[FeaturedCollectionKeyword], DiscoverFeaturedCollectionKeywordsUseCaseError>) -> Void
    )
}
