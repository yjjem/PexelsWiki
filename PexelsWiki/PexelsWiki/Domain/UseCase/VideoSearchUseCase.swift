//
//  PexelsVideoSearchUseCase.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.


import Foundation

protocol VideoSearchUseCaseInterface {
    
    func search(
        query: String,
        orientation: String,
        size: String,
        page: Int,
        perPage: Int,
        _ completion: @escaping (Result<VideoPage, Error>) -> Void
    )
}

final class VideoSearchUseCase: VideoSearchUseCaseInterface {
    
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
