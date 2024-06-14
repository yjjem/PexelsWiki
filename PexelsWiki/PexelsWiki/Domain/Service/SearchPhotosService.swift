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
        _ completion: @escaping (Result<SearchedPhotosPage, Error>) -> Void
    ) -> Cancellable? {
        return port.searchPhotos(
            query: parameters.query,
            orientation: parameters.orientation,
            size: parameters.size,
            page: parameters.page,
            perPage: parameters.perPage
        ) { response in
            
            completion(response)
        }
    }
}
