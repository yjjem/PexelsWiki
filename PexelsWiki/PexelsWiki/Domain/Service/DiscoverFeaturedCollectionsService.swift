//
//  DiscoverFeaturedCollectionsService.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.
    

final class DiscoverFeaturedCollectionsService: DiscoverFeaturedCollectionsUseCase {
    
    // MARK: Property(s)
    
    private let port: FetchFeaturedCollectionsPort
    
    init(port: FetchFeaturedCollectionsPort) {
        self.port = port
    }
    
    // MARK: Function(s)
    
    func discoverFeaturedCollections(
        _ command: DiscoverFeaturedCollectionsCommand,
        _ completion: @escaping (Result<[CollectionResource], DiscoverFeaturedCollectionUseCaseError>) -> Void
    ) -> Cancellable? {
        
        if command.requiresRefresh {
            port.resetPages()
        }
        
        return port.fetchFeaturedCollections { fetchResult in
            completion(fetchResult)
        }
    }
}
