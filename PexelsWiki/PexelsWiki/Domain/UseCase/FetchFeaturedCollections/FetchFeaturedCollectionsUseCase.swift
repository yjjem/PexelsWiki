//
//  FetchFeaturedCollectionsUseCase.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.
    

protocol FetchFeaturedCollectionsUseCase {
    func fetchFeaturedCollections(
        _ command: FetchFeaturedCollectionsCommand,
        _ completion: @escaping (Result<[CollectionResource], FetchFeaturedCollectionUseCaseError>) -> Void
    ) -> Cancellable?
}
