//
//  DataFactory.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.

import Foundation

struct DataFactory {
    
    // MARK: Property(s)
    
    private let cacheManager: CacheManager = CacheManager()
    private let apiFactory: APIFactory
    
    // MARK: Initializer(s)
    
    init(apiFactory: APIFactory) {
        self.apiFactory = apiFactory
    }
    
    // MARK: Repository(s)
    
    func makeDefaultSessionConfiguration() -> URLSessionConfiguration {
        let sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.requestCachePolicy = .returnCacheDataElseLoad
        sessionConfiguration.urlCache = cacheManager.urlCache
        sessionConfiguration.waitsForConnectivity = false
        return sessionConfiguration
    }

    func makeDefaultNetworkProvider() -> Networkable {
        return DefaultNetworkProvider(configuration: makeDefaultSessionConfiguration())
    }
    
    func makeVisualContentRepository() -> VisualContentRepositoryInterface {
        return VisualContentRepository(
            provider: makeDefaultNetworkProvider(),
            apiFactory: apiFactory
        )
    }
    
    func makeCuratedPhotosPort() -> CuratedPhotosPort {
        return CuratedPhotosWebRepository(
            provider: makeDefaultNetworkProvider(),
            apiFactory: apiFactory
        )
    }
    
    func makeSearchPhotosPort() -> SearchPhotosPort {
        return PhotosWebRepository(
            provider: makeDefaultNetworkProvider(),
            apiFactory: apiFactory
        )
    }
    
    func makeSpecificPhotoPort() -> SpecificPhotoPort {
        return SpecificPhotoWebRepository(
            provider: makeDefaultNetworkProvider(),
            apiFactory: apiFactory
        )
    }
}
