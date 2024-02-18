//
//  DataFactory.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.

struct DataFactory {
    
    // MARK: Property(s)
    
    private let networkProvider: Networkable
    private let apiFactory: APIFactory
    
    // MARK: Initializer(s)
    
    init(networkProvider: Networkable = DefaultNetworkProvider(), apiFactory: APIFactory) {
        self.networkProvider = networkProvider
        self.apiFactory = apiFactory
    }
    
    // MARK: Repository(s)
    
    func makeVisualContentRepository() -> VisualContentRepositoryInterface {
        return VisualContentRepository(provider: networkProvider, apiFactory: apiFactory)
    }
}
