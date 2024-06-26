//
//  FetchSingleVideoUseCase.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.


final class FetchSingleVideoUseCase: FetchSpecificVideoUseCase {
    
    // MARK: Property(s)
    
    private let repository: VisualContentRepositoryInterface
    
    // MARK: Initializer(s)
    
    init(repository: VisualContentRepositoryInterface) {
        self.repository = repository
    }
    
    func fetchVideoBy(
        id: Int,
        _ completion: @escaping (Result<SpecificVideo, Error>) -> Void
    ) -> Cancellable? {
        return repository.fetchVideoForID(id, completion)
    }
}
