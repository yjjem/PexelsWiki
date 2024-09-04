//
//  RetrieveCollectionMediaService.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.


final class RetrieveCollectionMediaService: FetchCollectionMediaUseCase {
    
    //MARK: Property(s)
    
    private let pagination: Pagination = Pagination(itemsPerPage: 30)
    private let port: FetchCollectionMediaPort
    private let collectionIdentifier: String
    
    init(port: FetchCollectionMediaPort, collectionIdentifier: String) {
        self.port = port
        self.collectionIdentifier = collectionIdentifier
    }
    
    // MARK: Function(s)
    
    @discardableResult
    func fetchCollectionMedia(
        _ completion: @escaping (Result<CollectionMedia, CollectionMediaUseCaseError>) -> Void
    ) -> Cancellable? {
        return port.fetchCollectionMedia(
            collectionIdentifier: collectionIdentifier,
            paginationInformation: pagination.currentPaginationInformation()
        ) { response in
            completion(response)
        }
    }
}
