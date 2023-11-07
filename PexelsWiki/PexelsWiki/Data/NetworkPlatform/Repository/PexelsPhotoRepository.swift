//
//  PexelsPhotoRepository.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.


final class PexelsPhotoRepository: PexelsPhotoRepositoryInterface {
    
    private let provider: Networkable
    
    init(provider: Networkable) {
        self.provider = provider
    }
    
    func loadCuratedPhotos(
        page: Int,
        perPage: Int,
        _ completion: @escaping (Result<PhotoPage, RepositoryError>) -> Void
    ) {
        let target: PexelsPhotoServiceTarget = .curatedPhotos(page: page, perPage: perPage)
        
        provider.load(target) { response in
            response.onComplete { data in
                let photoPage = data.toPhotoPage()
                completion(.success(photoPage))
            }
        }
    }
    
    func searchPhotos(
        query: String,
        orientation: String,
        size: String,
        page: Int,
        perPage: Int,
        _ completion: @escaping (Result<PhotoPage, RepositoryError>) -> Void
    ) {
        let target: PexelsPhotoServiceTarget = .searchPhotos(
            query: query,
            orientation: orientation,
            size: size,
            page: page,
            perPage: perPage
        )
        
        provider.load(target) { response in
            response.onComplete { data in
                let photoPage = data.toPhotoPage()
                completion(.success(photoPage))
            }
        }
    }
}
