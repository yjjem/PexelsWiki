//
//  FetchSingleVideoUseCase.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.
    

import Foundation

protocol FetchSingleVideoUseCaseInterface {
    func fetchVideoBy(
        id: Int,
        _ completion: @escaping (Result<VideoBundle, Error>) -> Void
    ) -> Cancellable?
}

final class FetchSingleVideoUseCase: FetchSingleVideoUseCaseInterface {
    
    // MARK: Property(s)
    
    private let repository: VisualContentRepositoryInterface
    
    // MARK: Initializer(s)
    
    init(repository: VisualContentRepositoryInterface) {
        self.repository = repository
    }
    
    func fetchVideoBy(
        id: Int,
        _ completion: @escaping (Result<VideoBundle, Error>) -> Void
    ) -> Cancellable? {
        return repository.fetchVideoForID(id, completion)
    }
}
