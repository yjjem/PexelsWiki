//
//  CollectionMediaWebRepository.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.


final class CollectionMediaWebRepository: FetchCollectionMediaPort {
    
    // MARK: Property(s)
    
    private let networkProvider: Networkable
    private let apiFactory: APIFactory
    
    init(networkProvider: Networkable, apiFactory: APIFactory) {
        self.networkProvider = networkProvider
        self.apiFactory = apiFactory
    }
    
    // MARK: Function(s)
    
    func fetchCollectionMedia(
        collectionIdentifier: String,
        paginationInformation: Pagination.PaginationInformation,
        _ completion: @escaping (Result<CollectionMedia, CollectionMediaUseCaseError>) -> Void
    ) -> Cancellable? {
        let collectionMediaEndPoint = apiFactory.makeCollectionMediaEndPoint(
            collectionIdentifier: collectionIdentifier,
            page: paginationInformation.page,
            itemsPerPage: paginationInformation.itemsPerPage
        )
        return networkProvider.send(request: collectionMediaEndPoint.makeURLRequest()) {
            response in
            let decodedResponse = response
                .flatMap { collectionMediaEndPoint.decode(data: $0) }
                .mapError { _ in CollectionMediaUseCaseError.unknown }
            completion(decodedResponse)
        }
    }
}
