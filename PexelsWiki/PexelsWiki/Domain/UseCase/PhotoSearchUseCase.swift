//
//  PexelsPhotoSearchUseCase.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.


import Foundation

protocol PhotoSearchUseCaseInterface {
    
    func search(
        query: String,
        orientation: String,
        size: String,
        page: Int,
        perPage: Int,
        _ completion: @escaping (Result<PhotoPage, Error>) -> Void
    )
}

final class PhotoSearchUseCase: PhotoSearchUseCaseInterface {
    
    private let repository: VisualContentRepositoryInterface
    
    init(repository: VisualContentRepositoryInterface) {
        self.repository = repository
    }
    
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
