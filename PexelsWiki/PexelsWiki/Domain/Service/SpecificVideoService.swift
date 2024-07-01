//
//  SpecificVideoService.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.


final class SpecificVideoService: FetchSpecificVideoUseCase {
    
    // MARK: Property(s)
    
    private let port: SpecificVideoPort
    
    // MARK: Initializer
    
    init(port: SpecificVideoPort) {
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
