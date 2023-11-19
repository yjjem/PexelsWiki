//
//  PexelsVideoSearchUseCase.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.


import Foundation

protocol PexelsVideoSearchUseCaseInterface {
    
    func search(
        query: String,
        orientation: String,
        size: String,
        page: Int,
        perPage: Int,
        _ completion: @escaping (Result<VideoPage, Error>) -> Void
    )
}

final class PexelsVideoSearchUseCase: PexelsVideoSearchUseCaseInterface {
    
    private let repository: PexelsVideoRepositoryInterface
    
    init(repository: PexelsVideoRepositoryInterface) {
        self.repository = repository
    }
    
    func search(
        query: String,
        orientation: String,
        size: String,
        page: Int,
        perPage: Int,
        _ completion: @escaping (Result<VideoPage, Error>) -> Void
    ) {
        repository.searchVideos(
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
