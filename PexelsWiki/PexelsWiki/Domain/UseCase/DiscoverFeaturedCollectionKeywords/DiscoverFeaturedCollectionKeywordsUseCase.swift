//
//  DiscoverFeaturedCollectionsKeywordUseCase.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.


protocol DiscoverFeaturedCollectionKeywordsUseCase {
    func featuredCollectionKeywords(
        _ completion: @escaping (Result<FeaturedCollectionKeyword, DiscoverFeaturedCollectionUseCaseError>) -> Void
    )
}
