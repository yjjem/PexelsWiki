//
//  PexelsPhotoSearchUseCase.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.


import Foundation

final class PhotoSearchUseCase: PhotoSearchUseCaseInterface {
    
    // MARK: Property(s)
    
    private let repository: VisualContentRepositoryInterface
    
    // MARK: Initializer
    
    init(repository: VisualContentRepositoryInterface) {
        self.repository = repository
    }
    
    // MARK: Function(s)
    
    func search(
        query: String,
        orientation: String,
        size: String,
        page: Int,
        perPage: Int,
        _ completion: @escaping (Result<PhotoPage, Error>) -> Void
    ) {
        repository.searchPhotos(
            query: query,
            orientation: orientation,
            size: size,
            page: page,
            perPage: perPage
        ) { response in
            
            completion(response)
        }
    }
}
