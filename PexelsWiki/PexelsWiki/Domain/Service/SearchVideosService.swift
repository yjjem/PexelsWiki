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
        _ command: SearchVideosCommand,
        _ completion: @escaping (Result<SearchedVideosResult, SearchVideosUseCaseError>) -> Void
    ) -> Cancellable? {
        return port.searchVideos(
            query: command.query,
            orientation: command.orientation,
            size: command.size
        ) { response in
            completion(response)
        }
    }
}
