//
//  PexelsVideoSearchUseCase.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.


import Foundation

final class VideoSearchUseCase: VideoSearchUseCaseInterface {
    
    struct SearchParameters {
        let query: String
        let orientation: String
        let size: String
        let page: Int
        let perPage: Int
    }
    
    // MARK: Property(s)
    
    private let repository: VisualContentRepositoryInterface
    
    // MARK: Initializer
    
    init(repository: VisualContentRepositoryInterface) {
        self.repository = repository
    }
    
    // MARK: Property(s)
    
    func search(
        _ parameters: SearchParameters,
        _ completion: @escaping (Result<VideoPage, Error>) -> Void
    ) {
        repository.searchVideos(
            query: parameters.query,
            orientation: parameters.orientation,
            size: parameters.size,
            page: parameters.page,
            perPage: parameters.perPage
        ) { response in
            
            completion(response)
        }
    }
}
