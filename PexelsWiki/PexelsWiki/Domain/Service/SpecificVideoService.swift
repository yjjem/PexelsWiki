//
//  SpecificVideoService.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.


final class SpecificVideoService: FetchSpecificVideoUseCase {
    
    // MARK: Property(s)
    
    private let port: FetchSpecificVideoPort
    
    // MARK: Initializer
    
    init(port: FetchSpecificVideoPort) {
        self.port = port
    }
    
    // MARK: Function(s)
    
    func fetchVideoBy(
        id: Int,
        _ completion: @escaping (Result<SpecificVideo, Error>) -> Void
    ) -> Cancellable? {
        return port.fetchVideoForID(id, completion)
    }
}
