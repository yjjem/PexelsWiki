//
//  FetchFeaturedCollectionsPort.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.
    

protocol FeaturedCollectionsPort {
    func fetchFeaturedCollections(
        _ completion: @escaping (Result<[CollectionResource], FetchFeaturedCollectionUseCaseError>) -> Void
    ) -> Cancellable?
    func resetPages()
}

