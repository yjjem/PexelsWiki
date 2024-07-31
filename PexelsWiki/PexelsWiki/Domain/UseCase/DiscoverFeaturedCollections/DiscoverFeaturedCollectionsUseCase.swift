//
//  DiscoverFeaturedCollectionsUseCase.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.
    

protocol DiscoverFeaturedCollectionsUseCase {
    func discoverFeaturedCollections(
        _ command: DiscoverFeaturedCollectionsCommand,
        _ completion: @escaping (Result<[CollectionResource], DiscoverFeaturedCollectionUseCaseError>) -> Void
    ) -> Cancellable?
}
