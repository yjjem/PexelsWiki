//
//  FetchFeaturedCollectionsPort.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.
    

protocol FetchFeaturedCollectionsPort {
    func fetchFeaturedCollections(
        _ completion: @escaping (Result<[CollectionResource], DiscoverFeaturedCollectionUseCaseError>) -> Void
    ) -> Cancellable?
    func resetPages()
}

