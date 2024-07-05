//
//  SearchPhotosService.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.


final class SearchPhotosService: SearchPhotosUseCase {
    
    // MARK: Property(s)
    
    private let port: SearchPhotosPort
    
    // MARK: Initializer
    
    init(port: SearchPhotosPort) {
        self.port = port
    }
    
    // MARK: Function(s)
    
    @discardableResult
    func search(
        _ parameters: SearchPhotosParameter,
        _ completion: @escaping (Result<SearchPhotosResult, SearchPhotosUseCaseError>) -> Void
    ) -> Cancellable? {
        return port.searchPhotos(parameters) { response in
            completion(response)
        }
    }
}
