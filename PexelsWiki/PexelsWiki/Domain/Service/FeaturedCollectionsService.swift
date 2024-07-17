//
//  FeaturedCollectionsService.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.
    

final class FeaturedCollectionsService: FetchFeaturedCollectionsUseCase {
    
    // MARK: Property(s)
    
    private let port: FetchFeaturedCollectionsPort
    
    init(port: FetchFeaturedCollectionsPort) {
        self.port = port
    }
    
    // MARK: Function(s)
    
    func fetchFeaturedCollections(
        _ command: FetchFeaturedCollectionsCommand,
        _ completion: @escaping (Result<[CollectionResource], FetchFeaturedCollectionUseCaseError>) -> Void
    ) -> Cancellable? {
        
        if command.requiresRefresh {
            port.resetPages()
        }
        
        return port.fetchFeaturedCollections { fetchResult in
            completion(fetchResult)
        }
    }
}
