//
//  CoreFactory.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.

final class CoreFactory {
    
    // MARK: Property(s)
    
    private var apiFactory: APIFactory
    
    init(userSecretKey: String) {
        self.apiFactory = APIFactory(secretKey: userSecretKey)
    }
    
    // MARK: Function(s)
    
    func updateUserKey(_ userKey: String) {
        apiFactory = APIFactory(secretKey: userKey)
    }
    
    // MARK: Factory(s)
    
    private func makeDataFactory() -> DataFactory {
        return DataFactory(apiFactory: apiFactory)
    }
    
    private func makeDomainFactory() -> DomainFactory {
        return DomainFactory(dataFactory: makeDataFactory())
    }
    
    func makePresentationFactory() -> SceneFactory {
        return SceneFactory(domainFactory: makeDomainFactory())
    }
}
