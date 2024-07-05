//
//  CuratedPhotosService.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.


final class CuratedPhotosService: FetchCuratedPhotosUseCase {
    
    // MARK: Property(s)
    
    private let port: CuratedPhotosPort
    
    // MARK: Initializer
    
    init(port: CuratedPhotosPort) {
        self.port = port
    }
    
    // MARK: Function(s)
    
    @discardableResult
    func fetchCuratedPhotos(
        _ completion: @escaping (Result<[CuratedPhoto], FetchCuratedPhotosUseCaseError>) -> Void
    ) -> Cancellable? {
        return port.fetchCuratedPhotos { response in
            completion(response)
        }
    }
    
    @discardableResult
    func reload(
        _ completion: @escaping (Result<[CuratedPhoto], FetchCuratedPhotosUseCaseError>) -> Void
    ) -> Cancellable? {
        port.reset()
        return port.fetchCuratedPhotos { response in
            completion(response)
        }
    }
}
