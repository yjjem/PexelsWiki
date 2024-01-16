//
//  CuratedPhotoUseCase.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.
    

import Foundation

final class PexelsPhotoUseCase: CuratedPhotosUseCaseInterface {
    
    // MARK: Property(s)
    
    private let repository: VisualContentRepositoryInterface
    
    init(repository: VisualContentRepositoryInterface) {
        self.repository = repository
    }
    
    // MARK: Function(s)
    
    func fetchCuratedPhotoPage(
        page: Int,
        perPage: Int,
        completion: @escaping (Result<PhotoPage, Error>) -> Void
    ) {
        repository.fetchCuratedPhotos(page: page, perPage: perPage) { response in
            completion(response)
        }
    }
}
