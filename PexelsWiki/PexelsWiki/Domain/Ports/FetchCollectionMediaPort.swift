//
//  FetchCollectionMediaPort.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.
    

protocol FetchCollectionMediaPort {
    func fetchCollectionMedia(
        collectionIdentifier: String,
        paginationInformation: Pagination.PaginationInformation,
        _ completion: @escaping (Result<CollectionMedia, CollectionMediaUseCaseError>) -> Void
    ) -> Cancellable?
}
