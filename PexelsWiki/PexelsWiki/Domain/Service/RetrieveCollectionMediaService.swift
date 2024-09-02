//
//  RetrieveCollectionMediaService.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.


final class RetrieveCollectionMediaService: FetchCollectionMediaUseCase {
    
    //MARK: Property(s)
    
    private let pagination: Pagination = Pagination(itemsPerPage: 30)
    private let port: FetchCollectionMediaPort
    
    init(port: FetchCollectionMediaPort) {
        self.port = port
    }
    
    // MARK: Function(s)
    
    @discardableResult
    func fetchCollectionMedia(
        _ targetCollectionIdentifier: String,
        _ completion: @escaping (Result<CollectionMedia, CollectionMediaUseCaseError>) -> Void
    ) -> Cancellable? {
        return port.fetchCollectionMedia(
            collectionIdentifier: targetCollectionIdentifier,
            paginationInformation: pagination.currentPaginationInformation()
        ) { response in
            completion(response)
        }
    }
}
