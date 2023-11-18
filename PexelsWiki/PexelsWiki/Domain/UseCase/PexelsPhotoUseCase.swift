//
//  CuratedPhotoUseCase.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.
    

import Foundation

protocol PexelsPhotoUseCaseInterface {
    
    func loadCuratedPhotoPage(
        page: Int,
        perPage: Int,
        completion: @escaping (Result<PhotoPage, Error>) -> Void
    )
}

final class PexelsPhotoUseCase: PexelsPhotoUseCaseInterface {
    
    private let repository: PexelsPhotoRepositoryInterface
    
    init(repository: PexelsPhotoRepositoryInterface) {
        self.repository = repository
    }
    
    func loadCuratedPhotoPage(
        page: Int,
        perPage: Int,
        completion: @escaping (Result<PhotoPage, Error>) -> Void
    ) {
        repository.loadCuratedPhotos(page: page, perPage: perPage) { response in
            completion(response.mapError { $0 as Error })
        }
    }
}
