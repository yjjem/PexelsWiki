//
//  SearchVideosService.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.


final class SearchVideosService: SearchVideosUseCase {
    
    // MARK: Property(s)
    
    private let port: SearchVideosPort
    
    // MARK: Initializer
    
    init(port: SearchVideosPort) {
        self.port = port
    }
    
    // MARK: Function(s)
    
    @discardableResult
    func search(
        _ parameters: SearchVideosParameter,
        _ completion: @escaping (Result<SearchedVideosResult, SearchVideosUseCaseError>) -> Void
    ) -> Cancellable? {
        return port.searchVideos(
            query: parameters.query,
            orientation: parameters.orientation,
            size: parameters.size
        ) { response in
            completion(response)
        }
    }
}
