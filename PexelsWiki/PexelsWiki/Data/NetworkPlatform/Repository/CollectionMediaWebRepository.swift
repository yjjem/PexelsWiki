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
        _ targetCollectionIdentifier: String,
        _ completion: @escaping (Result<CollectionMedia, CollectionMediaUseCaseError>) -> Void
    ) -> Cancellable? {
        let collectionMediaEndPoint = apiFactory.makeCollectionMediaEndPoint(
            collectionIdentifier: targetCollectionIdentifier
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
