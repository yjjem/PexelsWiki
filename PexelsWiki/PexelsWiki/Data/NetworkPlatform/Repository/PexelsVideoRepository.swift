//
//  PexelsVideoRepository.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.


final class PexelsVideoRepository: PexelsVideoRepositoryInterface {
    
    private let provider: Networkable
    
    init(provider: Networkable) {
        self.provider = provider
    }
    
    func loadPopularVideos(
        minWidth: Int,
        minHeight: Int,
        minDuration: Int,
        maxDuration: Int,
        page: Int,
        perPage: Int,
        _ completion: @escaping (Result<VideoPage, RepositoryError>) -> Void
    ) {
        let target: PexelsVideoServiceTarget = .popularVideos(
            minWidth: minWidth,
            minHeight: minHeight,
            minDuration: minDuration,
            maxDuration: maxDuration,
            page: page,
            perPage: perPage
        )
        
        provider.load(target) { response in
            response.onComplete { data in
                let videoPage = data.toVideoPage()
                completion(.success(videoPage))
            }
        }
    }
    
    func searchVideos(
        query: String,
        orientation: ContentOrientation,
        size: ContentSize,
        page: Int,
        perPage: Int,
        _ completion: @escaping (Result<VideoPage, RepositoryError>) -> Void
    ) {
        let target: PexelsVideoServiceTarget = .searchVideos(
            query: query,
            orientation: orientation,
            size: size,
            page: page,
            perPage: perPage
        )
        
        provider.load(target) { response in
            response.onComplete { data in
                let videoPage = data.toVideoPage()
                completion(.success(videoPage))
            }
        }
    }
}
