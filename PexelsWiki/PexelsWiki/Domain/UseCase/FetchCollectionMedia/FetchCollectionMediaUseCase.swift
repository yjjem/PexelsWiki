//
//  FetchCollectionMediaUseCase.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.
    

protocol FetchCollectionMediaUseCase {
    func fetchCollectionMedia(
        _ targetCollectionIdentifier: String,
        _ completion: @escaping (Result<CollectionMedia, CollectionMediaUseCaseError>) -> Void
    ) -> Cancellable?
}
