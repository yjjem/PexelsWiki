//
//  SpecificPhotoService.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.


final class SpecificPhotoService: FetchSpecificPhotoUseCase {
    
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
        _ completion: @escaping (Result<SpecificPhoto, Error>) -> Void
    ) -> Cancellable? {
        return repository.fetchPhotoForID(id, completion)
    }
}
