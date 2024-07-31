//
//  DiscoverCuratedPhotosService.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.


final class DiscoverCuratedPhotosService: DiscoverCuratedPhotosUseCase {
    
    // MARK: Property(s)
    
    private let port: CuratedPhotosPort
    
    // MARK: Initializer
    
    init(port: CuratedPhotosPort) {
        self.port = port
    }
    
    // MARK: Function(s)
    
    @discardableResult
    func fetchCuratedPhotos(
        _ completion: @escaping (Result<[CuratedPhoto], DiscoverCuratedPhotosUseCaseError>) -> Void
    ) -> Cancellable? {
        return port.fetchCuratedPhotos { response in
            completion(response)
        }
    }
    
    @discardableResult
    func reload(
        _ completion: @escaping (Result<[CuratedPhoto], DiscoverCuratedPhotosUseCaseError>) -> Void
    ) -> Cancellable? {
        port.reset()
        return port.fetchCuratedPhotos { response in
            completion(response)
        }
    }
}
