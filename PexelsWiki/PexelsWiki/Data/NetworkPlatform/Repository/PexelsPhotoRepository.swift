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
        _ completion: @escaping (Result<PhotoPage, Error>) -> Void
    ) {
        let target: PexelsPhotoServiceTarget = .curatedPhotos(page: page, perPage: perPage)
        
        provider.load(target) { result in
            let mappedResult = result.map { $0.toPhotoPage() }
            completion(mappedResult)
        }
    }
    
    func searchPhotos(
        query: String,
        orientation: String,
        size: String,
        page: Int,
        perPage: Int,
        _ completion: @escaping (Result<PhotoPage, Error>) -> Void
    ) {
        let target: PexelsPhotoServiceTarget = .searchPhotos(
            query: query,
            orientation: orientation,
            size: size,
            page: page,
            perPage: perPage
        )
        
        provider.load(target) { result in
            let mappedResult = result.map { $0.toPhotoPage() }
            completion(mappedResult)
        }
    }
}
