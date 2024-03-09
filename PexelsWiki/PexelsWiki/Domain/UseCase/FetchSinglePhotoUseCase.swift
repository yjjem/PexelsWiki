//
//  FetchSinglePhotoUseCase.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.
    

import Foundation

protocol FetchSinglePhotoUseCaseInterface {
    
    func fetchPhoto(id: Int, _ completion: (Result<PhotoBundle, Error>) -> Void) -> Cancellable?
}

final class FetchSinglePhotoUseCase {
    
    // MARK: Property(s)
    
    private let repository: VisualContentRepositoryInterface
    
    // MARK: Initializer
    
    init(repository: VisualContentRepositoryInterface) {
        self.repository = repository
    }
    
    // MARK: Function(s)
    
    @discardableResult
    func fetchPhoto(
        id: Int,
        _ completion: @escaping (Result<PhotoBundle, Error>) -> Void
    ) -> Cancellable? {
        return repository.fetchPhotoForID(id, completion)
    }
}
